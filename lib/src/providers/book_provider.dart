import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_final/src/models/book.dart';

class BookProvider 
{
  Future<List<Book>> getAllBooks() async
  {
    final db = FirebaseFirestore.instance;
    final collectionRefBooks = db.collection('users');
    final snapshotBooks = await collectionRefBooks.get();

    final books = List<Book>.from
    (
      snapshotBooks.docs.map
      (
        (book) 
        {
          return Book.fromJson({'id': book.id, ...book.data()});
        }
      )
    );
    return books;
  }

  Stream<List<Book>> getAllBooksStream() 
  {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final db = FirebaseFirestore.instance;

    final collectionRefBooks = db
    .collection('users')
    .doc(userId)
    .collection('books') 
    .limit(12);

    final snapshotBooks = collectionRefBooks.snapshots();

    final books = snapshotBooks.map((snapshot) 
    {
      return snapshot.docs.map((book) 
      {
        return Book.fromJson({'id': book.id, ...book.data()});
      }).toList();
    });

    return books;
  }

  Future<void> saveBook(Map<String, dynamic> book) async 
  {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance;

    final collectionRefBooks = db.collection('users')
    .doc(user.currentUser?.uid)
    .collection('books');

    await collectionRefBooks.add(book);
  }

  Future<bool> markAsComplete({required String docId, required String value,}) async 
  {
    try 
    {
      final db = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance;

      final docRef = db.collection('users')
      .doc(user.currentUser?.uid)
      .collection('books')
      .doc(docId);

      await docRef.update({'status': value});
      return true;
    } catch (e) 
    {
      return false;
    }
  }
}