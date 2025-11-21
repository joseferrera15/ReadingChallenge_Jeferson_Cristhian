import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:proyecto_final/src/widgets/SliderListTile.dart';
import 'package:proyecto_final/src/widgets/LinearProgress.dart';

class Stadistics extends StatefulWidget 
{
  const Stadistics({super.key});

  @override
  State<Stadistics> createState() => _StadisticsState();
}

class _StadisticsState extends State<Stadistics>
{
  double progress = 0;

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar
      (
        title: const Text('Estadísticas', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
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
                  ),
                  pagesRead: 20,
                  totalPages: 100,
                  )
                )
              )
          );
        })
      ),
          //],
        //),
      //)
      bottomNavigationBar: BottomAppBar
      (
        height: 30,
        color: const Color.fromARGB(255, 247, 247, 244),
        clipBehavior: Clip.antiAlias,
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 28,),
              onPressed: () {context.go( '/home' );},
            ),
            IconButton(
              icon: const Icon(Icons.line_axis_rounded, color: Colors.black, size: 28,),
              onPressed: () {context.go( '/stadistics' );},
            ),
          ],
        ),
      ),
    );
  }
}