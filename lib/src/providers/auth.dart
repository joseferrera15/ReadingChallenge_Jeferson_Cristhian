import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthProvider 
{
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserWithEmailAndPassword(BuildContext context, String email, String password) async 
  {
    try 
    {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    
      await _checkAndCreateUserDocument(FirebaseAuth.instance.currentUser!, context, password);
    } 
    catch (e) 
    {
      print("Error en iniciar sesion por correo: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, context) async 
  {
    try 
    {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    
      await _checkAndCreateUserDocument(userCredential.user!, context, password);
    } catch (e) 
    {
      print("Error en iniciar sesion por correo: $e");
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
      print("Error en Google Sign-In: $e");
    }
  }

  Future<void> _checkAndCreateUserDocument(User user, BuildContext context, String? password) async 
  {
    final userDoc = _firestore.collection('users').doc(user.uid);
    
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) 
    {
      // Crear nuevo documento si no existe
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
    } else 
    {
      // Actualizar último login si ya existe
      await userDoc.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }

    context.go('/home');
  }
}