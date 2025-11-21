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

  Stream<List<Book>> getAllBooksStream() {
    final db = FirebaseFirestore.instance;
    final collectionRefBooks = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
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

  Future<void> saveBook(Map<String, dynamic> book) async {
    final db = FirebaseFirestore.instance;

    final collectionRefBooks = db.collection('books');

    await collectionRefBooks.add(book);

    // return Todo.fromJson({'id': newTodo.id, ...todo});
  }

  Future<bool> markAsComplete({
    required String docId,
    required bool value,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      final docRef = db.collection('todos').doc(docId);

      await docRef.update({'completed': value});
      return true;
    } catch (e) {
      return false;
    }
  }
}