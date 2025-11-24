import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      Icon(Icons.timer_outlined, color: Colors.blue, size: 60),
                      SizedBox(width: 10),
                      Text(
                        '00:30',
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(width: 30,),
                      Row(
                        
                        children: [
                          SizedBox(height: 16),
                            
                            SizedBox(height: 16),
                            FloatingActionButton(onPressed: (){
                          
                            },
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.timer),
                            ),
                            SizedBox(height: 16, width: 30,),
                            
                            SizedBox(height: 16),
                            FloatingActionButton(onPressed: (){
                          
                            },
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.stop),
                            ),
                        ],
                      ),
                    ],
                    
                  
                )
                    
                  ),
                
              ),
              
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
                  