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
              child: Cronometer(
                
              ),
              
            )
          );
        }

}


/*Row(
                  children: [
                        SizedBox(height: 16),
                        Text(
                          'Iniciar',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(onPressed: (){

                        },
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.timer),
                        ),
                        SizedBox(height: 16, width: 30,),
                        Text(
                          'Stop',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(onPressed: (){

                        },
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.stop),
                        ),
                  ]
                  
                )*/
                  