import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_final/src/models/book.dart';

class BookProvider
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Book>> getBooksByStatusStream(String status) 
  {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Parece ser innecesario, pero por si acaso
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
    .collection('users')
    .doc(userId)
    .collection('books')
    .where('status', isEqualTo: status)
    .limit(12)
    .snapshots()
    .map((snapshot) 
    {
      return snapshot.docs.map((book) {
        return Book.fromJson({'id': book.id, ...book.data()});
      }).toList();
    });
  }

  Stream<List<Book>> searchBooksStream() 
  {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('books')
        .orderBy('title')
        .limit(12)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((book) {
            return Book.fromJson({'id': book.id, ...book.data()});
          }).toList();
        });
  }


  Stream<List<Book>> getBooksStream({String? statusFilter}) 
  {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    Query collectionRefBooks = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books');

    // Aplicar filtro si se proporciona
    if (statusFilter != null) {
      collectionRefBooks = collectionRefBooks.where('status', isEqualTo: statusFilter);
    }

    return collectionRefBooks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromJson({'id': doc.id, ...(doc.data() as Map<String, dynamic>)});
      }).toList();
    });
  }

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


  // estadisticas realess
  Future<Map<String, dynamic>> getUserStats() async 
  {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return {'totalBooks': 0, 'totalPages': 0, 'daysStreak': 0};
    
    final db = FirebaseFirestore.instance;
    final userBooksRef = db.collection('users').doc(userId).collection('books');
    
    final snapshot = await userBooksRef.get();
    
    int totalBooks = snapshot.docs.length;
    int totalPages = 0;
    
    for (var doc in snapshot.docs) 
    {
      final data = doc.data();
      totalPages += (data['totalPages'] as int? ?? 0);
    }
    
    return 
    {
      'totalBooks': totalBooks,
      'totalPages': totalPages,
      'daysStreak': 0, 
    };
  }

  //actualizar paginas leidas
  Future<bool> updateCurrentPage({required String bookId, required int currentPage}) async 
  {
    try 
    {
      final db = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return false;

      final docRef = db.collection('users')
      .doc(user.uid)
      .collection('books')
      .doc(bookId);

      await docRef.update({
        'currentPage': currentPage,
        'status': 'En Progreso',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return true;
    } 
    catch (e) 
    {
      return false;
    }
  }
}