import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/chronometer_provider.dart';

class StartReadPage extends StatefulWidget {

const StartReadPage({super.key});

  @override
  State<StartReadPage> createState() => _StartReadPage();


}
class _StartReadPage extends State<StartReadPage> 
{
      @override
        Widget build(BuildContext context) 
        {
          return Scaffold(
            appBar: AppBar(
              title: Text('Seguimiento'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  Cronometer(
                
                     ),
                  SizedBox(height: 30,),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Paginas Leidas'),
                      hint: Text('Eje. Crear opción de eliminar'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.pages),
                    ),

                  )
                ],
              )
              
              
            )
          );
        }

}


