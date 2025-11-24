import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/api/books.dart';
import 'package:proyecto_final/src/shared/utils.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';

class AdminBookPage extends StatefulWidget 
{
  AdminBookPage({super.key, this.book});

  final Map<String, dynamic>? book;

  @override
  State<AdminBookPage> createState() => _AdminTodoPageState();
}

class _AdminTodoPageState extends State<AdminBookPage> 
{
  final titleController = TextEditingController();
  final autorController = TextEditingController();
  final estadoController = TextEditingController();
  final paginasLeidasController = TextEditingController();
  final paginasTotalesController = TextEditingController();

  final FocusNode titleFocus = FocusNode();

  final bookProvider = BookProvider();
  File? _image;
  //image picker
  final _picker = ImagePicker();

  pickImage()async
  {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) 
    {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) 
  {
    //Id que me permite consultar a la BBDD la información actualizada
    final bookId = GoRouterState.of(context).pathParameters['id'];
    //Lista de Estados
    final List<String>_listEstado = ['Pendiente', 'Finalizado','En progreso'];
    String? _selectedEstado;

    List<DropdownMenuItem<String>> _buildDropdownMenuItems() 
    {
      return _listEstado.map((String estado) 
      {
        return DropdownMenuItem<String>(
          value: estado,
          child: Text(estado),
        );
      }).toList();
    }

    if (widget.book != null) 
    {
      titleController.text = widget.book!['title'];
      autorController.text = widget.book!['author'];
      _image = File(widget.book!['cover']);
      paginasLeidasController.text = widget.book!['currentPage'].toString();
      paginasTotalesController.text = widget.book!['totalPages'].toString();
      estadoController.text = widget.book!['status'];
    }

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(
          widget.book == null
              ? 'Agregando nuevo libro'
              : 'Editando el progreso del libro # $bookId',
        ),
      ),
      body: SingleChildScrollView 
      (
        padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
        
        child: Column(
          children: [
            //codigo donde hacemos stack el floating action button con el Image
           Stack(
              children: [
                SizedBox(
                  width: 400, // Personaliza el ancho
                  height: 300, // Personaliza el alto
                  child: 
                  _image != null ? Image.file(_image!, errorBuilder: (context, error, stackTrace) => Image(
                        image: NetworkImage("https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg"),
                        fit: BoxFit.cover)) : Image(
                      image: NetworkImage("https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg"),
                      fit: BoxFit.cover)
                     // Ajusta la imagen al espacio
                  ),
                
                Positioned(
                  bottom: 10,
                  left: 150,
                  child: FloatingActionButton(
                    onPressed: () {
                      pickImage();
                    },
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add_photo_alternate),
                  ),
                )
              ],
            ),
            
            SizedBox(height: 16),
            TextField
            (
              focusNode: titleFocus,
              controller: titleController,
              maxLength: 21,

              decoration: InputDecoration
              (
                label: Text('Title'),
                hint: Text('Physics For Engineers'),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                prefixIcon: Icon(Icons.text_fields_rounded),
              ),

              maxLines: 1,
              obscureText: false,
              keyboardType: TextInputType.visiblePassword,
              // style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),

            TextField(
              controller: autorController,
              maxLength: 20,
              maxLines: 1,
              decoration: InputDecoration(
                label: Text('Author'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person),
                ),
            ),
            SizedBox(height: 16),

            //Implementacion del DropdownButtonFormField para la seleccion de estados.
            DropdownButtonFormField<String>(
                initialValue: _selectedEstado, 
                items: _buildDropdownMenuItems(), 
                onChanged: (String? newValue) {
                      setState(() {
                      _selectedEstado = newValue; 
                });
                },
                    decoration: InputDecoration(
                      labelText: 'Estado', 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.check_box), 
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Porfavor selecciona un Estado'; // Optional validation
                      }
                      return null;
                    },
            ),
            SizedBox(height: 16),
                    TextField(
                      controller: paginasLeidasController,
                      maxLines: 1,
                      //Teclado  numerico y no aceptara caracteres especiales.
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      decoration: InputDecoration(
                        label: Text('Paginas Leidas'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.menu_book),
                        ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: paginasTotalesController,
                      maxLength: 20,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      decoration: InputDecoration(
                        label: Text('Paginas Totales'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.menu_book),
                        ),
                    ),
                    
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton
      (
        heroTag: 'tag_agregar_libro',
        backgroundColor: Colors.blue[300],
        onPressed: () async 
        {
          if (titleController.text.isEmpty) 
          {
            Utils.showSnackBar(
              context: context,
              title: "The title is necessary.",
              color: Colors.red,
            );

            return;
          }
          if (autorController.text.isEmpty) 
          {
            Utils.showSnackBar(
              context: context,
              title: "The author is necessary.",
              color: Colors.red,
            );

            return;
          }
          if (paginasLeidasController.text.isEmpty) 
          {
            Utils.showSnackBar(
              context: context,
              title: "Write down the pages you have read.",
              color: Colors.red,
            );

            return;
          }
          if (paginasTotalesController.text.isEmpty) 
          {
            Utils.showSnackBar(
              context: context,
              title: "Write the total number of pages.",
              color: Colors.red,
            );
            
            return;
          }

          final Map<String, dynamic> newBook = 
          {
            'title': titleController.text,
            'author': autorController.text,
            'cover': _image?.path ?? "https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg",
            'status': int.parse(paginasLeidasController.text) == 0 ? 'Pendiente': 'En Progreso',
            'currentPage': int.parse(paginasLeidasController.text),
            'totalPages': int.parse(paginasTotalesController.text),
            'user': FirebaseAuth.instance.currentUser?.uid,
          };

          if (bookId == null) 
          {
            await bookProvider.saveBook(newBook);
          } 
          else 
          {
            final indice = booksList.indexWhere((book) => book['id'].toString() == bookId);

            booksList[indice] = newBook;
          }

          if (!context.mounted) return;

          Utils.showSnackBar(
            context: context,
            title: "Book added succesfully.",
          );

          titleController.text = '';
          autorController.text = '';

          context.pop();
        },
        child: Icon(Icons.add, color: Colors.blue[50]),
      ),
    );
    }
}