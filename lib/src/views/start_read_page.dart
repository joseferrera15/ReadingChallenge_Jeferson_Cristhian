import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/safe_cronometer_provider.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';

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

final TextEditingController _pageController = TextEditingController();
final BookProvider _bookProvider = BookProvider();
bool _isLoading = false;
 @override
  void initState() 
  {
    super.initState();
  }

  @override
  void dispose() 
  {
    _pageController.dispose();
    super.dispose();
  }

  Future<void>_ActualizarPaginasLeidas() async
  {
    final newPage = int.tryParse(_pageController.text)??0;
    
    if ((widget.bookData['currentPage']+newPage) == widget.bookData['totalPages']) 
    {
      final success = await _bookProvider.updateCurrentPage(
        bookId: widget.bookId,
        currentPage: (widget.bookData['currentPage'] + newPage),
        totalPages: widget.bookData['totalPages'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book completed!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
      return;
    }
    if((widget.bookData['currentPage']+newPage) > widget.bookData['totalPages'])
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The current page number must not exceed the total number of pages.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() { _isLoading = true; });

    final success = await _bookProvider.updateCurrentPage(
      bookId: widget.bookId,
      currentPage: (widget.bookData['currentPage'] + newPage),
      totalPages: widget.bookData['totalPages']
    );

    setState(() {
      _isLoading = false;
    });
    if (success) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress Updated Succesfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } 
    else 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Updating Progress'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
              controller: _pageController,
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
                    const SizedBox(height: 20),
                    Text('Título: ${widget.bookData['title']}'),
                    Text('Autor: ${widget.bookData['author']}'),
                    Text('Páginas: ${widget.bookData['currentPage']} / ${widget.bookData['totalPages']}'),
                    
                  
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            FloatingActionButton.extended(onPressed: (){
                      _isLoading ? null : _ActualizarPaginasLeidas();
                      label: _isLoading ;
                    },
                    label: Text('Registrar Paginas Leidas', style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.check, color: Colors.white),

                    
                    )
          ],
        ),
      ),
    );
  }
}