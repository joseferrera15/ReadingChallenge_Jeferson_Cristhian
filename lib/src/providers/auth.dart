import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthProvider 
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserWithEmailAndPassword(BuildContext context, String email, String password) async 
  {
    try 
    {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
    
      await userDoc.set
      ({
        'uid': userCredential.user!.uid,
        'email': email,
        'password': password,
        'displayName': '', // Nombre por defecto
        'photoURL': '',
        'provider': 'password',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registro exitoso!"),
          backgroundColor: const Color.fromARGB(255, 214, 92, 92),
        ),
      );


      if (context.mounted) 
      {
        context.go('/home');
      }

      //await _checkAndCreateUserDocument(FirebaseAuth.instance.currentUser!, context, password);
    } 
    catch (e) 
    {
      print("Error en iniciar sesion por correo: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async 
  {
    try 
    {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) 
      {
        // Crear documento si no existe (primer inicio de sesión)
        await userDoc.set
        ({
          'uid': userCredential.user!.uid,
          'email': email,
          'password': password, // Guardamos la contraseña para referencia
          'displayName': userCredential.user!.displayName ?? '',
          'photoURL': '',
          'provider': 'password',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print("Nuevo usuario creado en Firestore");
      }
      else 
      {
        // Actualizar último login
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print("Usuario existente, último login actualizado");
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Inicio de sesion exitoso!"),
          backgroundColor: const Color.fromARGB(255, 92, 200, 214),
        ),
      );
    
      if (context.mounted) 
      {
        context.go('/home');
      }
      
    } catch (e) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en iniciar sesion por correo: ${e.toString()}"),
          backgroundColor: const Color.fromARGB(255, 214, 92, 92),
        ),
      );
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async 
  {
    try
    {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(serverClientId: '1077986394972-ku1lckvvac0scjt4ht3074m9ceb2ntks.apps.googleusercontent.com');

      // Obtain the auth details from the request
      final GoogleSignInAccount googleAuth = await signIn.authenticate();

      // Obtenemos el id token
      final GoogleSignInAuthentication auth = googleAuth.authentication;
      String? idToken = auth.idToken;


      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await _checkAndCreateUserDocument(FirebaseAuth.instance.currentUser!, context, null);
    } catch (e) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en iniciar sesion por google: ${e.toString()}"),
          backgroundColor: const Color.fromARGB(255, 214, 92, 92),
        ),
      );
    }
  }

  Future<void> _checkAndCreateUserDocument(User user, BuildContext context, String? password) async 
  {
    final userDoc = _firestore.collection('users').doc(user.uid);
    
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) 
    {
      // Crear nuevo documento si no existe
      print(user.providerData.first);

      if (user.providerData.first != "google.com") 
      {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'password': password,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? '',
          'provider': user.providerData[0].providerId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
      else
      {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? '',
          'provider': user.providerData[0].providerId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      context.go('/home');
    } 
    else 
    {
      print("Ya existe el usuario");
      // Actualizar último login si ya existe
      //final userData = docSnapshot.data() as Map<String, dynamic>?;
      //final storedPassword = userData?['password'] as String?;

      //if (password == storedPassword) 
      //{
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      //}
      //else
      //{
       /* ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(
            content: Text('Email or password are incorrect. Try again!'),
            backgroundColor: const Color.fromARGB(255, 206, 60, 35),
          ),
        );

        context.go('/login');*/
      //}
    }

    context.go('/home');
  }
}