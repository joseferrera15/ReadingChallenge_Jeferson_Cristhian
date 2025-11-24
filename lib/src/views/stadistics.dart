import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:proyecto_final/src/shared/utils.dart';
import 'package:proyecto_final/src/widgets/SliderListTile.dart';
import 'package:proyecto_final/src/widgets/LinearProgress.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';
import 'package:proyecto_final/src/models/book.dart';

class Stadistics extends StatefulWidget {
  const Stadistics({super.key});

  @override
  State<Stadistics> createState() => _StadisticsState();
}

class _StadisticsState extends State<Stadistics>
{
  BookProvider bookProvider = BookProvider();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() 
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('My Books & Progress', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(223, 0, 0, 0)),),
        elevation: 0.4,
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        shadowColor: Color(0xFFE5E5E5),

        bottom: PreferredSize
        (
          preferredSize: Size.fromHeight(50),
          
          child: Container 
          ( 
            color: Colors.white,
            child: Row
            (
              spacing: 40,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: 
              [
                Text('Book Analytics'),

                Row(
                  children: 
                  [
                  Text("Order by"),
                  PopupMenuButton<String>
                  (
                    onSelected: (value) 
                    {
                      switch (value) 
                      {
                        case 'All':
                          final db = FirebaseFirestore.instance;

                          bookProvider.getAllBooksStreamWithCondition(
                          db.collection('users')
                          .doc(user?.uid)
                          .collection('books'));
                          
                          break;
                        case 'Pending':
                          final db = FirebaseFirestore.instance;

                          bookProvider.getAllBooksStreamWithCondition(
                            db.collection('users')
                            .doc(user?.uid)
                            .collection('books')
                            .where('currentPage', isEqualTo: 0)
                          );
                          break;
                        case 'InProgress':
                          final db = FirebaseFirestore.instance;

                          bookProvider.getAllBooksStreamWithCondition(
                            db.collection('users')
                            .doc(user?.uid)
                            .collection('books')
                            .where('currentPage', isGreaterThan: 0)
                          );
                          break;
                        case 'Completed':
                          final db = FirebaseFirestore.instance;

                          bookProvider.getAllBooksStreamWithCondition(
                            db.collection('users')
                            .doc(user?.uid)
                            .collection('books')
                            .where('currentPage', isEqualTo: 'totalPages')
                          );
                          
                          break;

                        default: return;
                      }
                    },
                    itemBuilder: (context) => 
                    [
                      PopupMenuItem(value: 'All', child: Text('All')),
                      PopupMenuItem(value: 'Pending', child: Text('Pending')),
                      PopupMenuItem(value: 'In Progress', child: Text('InProgress')),
                      PopupMenuItem(value: 'Completed', child: Text('Completed')),
                      PopupMenuItem(value: 'Favorites', child: Text('Favorites')),
                      PopupMenuItem(value: 'Alphabetical', child: Text('Alphabetical')),
                    ],
                    icon: Icon(Icons.tune_rounded)
                  )
                ])
              ]
            ),
          )
        ),
      ),

      body: StreamBuilder
      (
        stream: bookProvider.getAllBooksStream(), 
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) 
          {
            return Text('!data');
          }
          if (snapshot.hasError) 
          {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          final List<Book> books = snapshot.data!;

          return ListView.builder
          (
            itemCount: books.length,
            itemBuilder: (BuildContext context, index)
            {
              return ExpansionTile
              (
                title: Title(color: Colors.amberAccent, child: Text(books[index].title)),

                children: 
                [
                  Image(image: NetworkImage("https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg"), width: 100,)
                ],
              );
          });
        }
      ),

      


      /*
      body: AnimationLimiter
      (
        child: ListView.builder(itemCount: 12, itemBuilder: (BuildContext context, int index)
        {
          return AnimationConfiguration.staggeredList
          (
            position: index,
            duration: const Duration(milliseconds: 250),
            child: SlideAnimation(
                  //verticalOffset: 50.0,
              child: FadeInAnimation(
                child: SliderListTile(
                  title: 'Libro ${index + 1}',
                  author: 'sa',
                  trailing: LinearProgres
                  (
                    value: 0.5, min: 4
=======
class _StadisticsState extends State<Stadistics> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            print("yendo al home");
            context.go('/home');
          },
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                //verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: SliderListTile(
                    title: 'Libro ${index + 1}',
                    author: 'sa',
                    trailing: LinearProgres(value: 0.5, min: 4),
                    pagesRead: 20,
                    totalPages: 100,
>>>>>>> f2d3231114edee5b81d7a93497654778e8adaa37
                  ),
                ),
              ),
            );
          },
        ),
      ),
<<<<<<< HEAD
      */

      bottomNavigationBar: BottomAppBar
      (
        height: 50,
        elevation: 0.2,
        shadowColor: Color(0xFFE5E5E5),
        notchMargin: 0,
        padding: EdgeInsets.all(0),

        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                IconButton(
                  onPressed: () 
                  {
                    context.go('/home');
                  },
                  icon: Icon(Icons.home, size: 35, color: const Color.fromARGB(255, 31, 31, 31),),
                ),

                IconButton(
                  onPressed: () 
                  {
                    context.go('/stadistics');
                  },
                  icon: Icon(Icons.line_axis_rounded, size: 35, color: const Color.fromARGB(255, 31, 31, 31),),
                ),
              ],
            ),
        ),
      );
  }
}
