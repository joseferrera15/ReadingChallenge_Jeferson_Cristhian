import 'package:flutter/material.dart';

class WidgetBook extends StatelessWidget
{
  final String title;
  final String author;
  final String imageUrl;
  final double pagesRead; // Este es el valor actual del slider
  final double totalPages; // Este es el maximo valor del slider

  WidgetBook(
    this.title, this.author, this.imageUrl, this.pagesRead, this.totalPages
  );

  Widget build(BuildContext context) 
  {
    return Container
    (
      width: 200,
      height: 150,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
    );
  }
}