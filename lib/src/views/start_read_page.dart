import 'package:flutter/material.dart';
import 'package:proyecto_final/src/providers/safe_cronometer_provider.dart';

class StartReadPage extends StatefulWidget {
  final String bookId;
  final Map<String, dynamic> bookData;

  const StartReadPage({
    super.key,
    required this.bookId,
    required this.bookData,
  });
  
  @override
  State<StartReadPage> createState() => _StartReadPageState(); 
}

class _StartReadPageState extends State<StartReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento: ${widget.bookData['title']}'), 
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
        child: Column(
          children: [
            SafeCronometer(
              
            ), 
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                label: const Text('Páginas Leídas'),
                hintText: 'Ingresa las páginas leídas', 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.pages),
              ),
            ),
            const SizedBox(height: 20),
            // Agregar más contenido relacionado con el libro
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Información del Libro',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text('Título: ${widget.bookData['title']}'),
                    Text('Autor: ${widget.bookData['author']}'),
                    Text('Páginas: ${widget.bookData['currentPage']} / ${widget.bookData['totalPages']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}