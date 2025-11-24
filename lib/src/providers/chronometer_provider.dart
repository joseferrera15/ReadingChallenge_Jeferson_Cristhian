
import 'dart:async';
import 'package:flutter/material.dart';


class Cronometer extends StatefulWidget {
  const Cronometer({super.key});

  @override
  State<Cronometer> createState() => _Cronometer();
}

class _Cronometer extends State<Cronometer> {
  int milisegundos = 0;
  bool estaIniciado = false;
  late Timer timer;
  void iniciarCronometro(){
    if(!estaIniciado){
          timer = Timer.periodic(Duration(milliseconds: 100), (timer){
          this.milisegundos += 100;
          setState(() {
            
          });
        });
        estaIniciado = true;
    }
  }
  void detenerCronometro() {
    if (estaIniciado) {
      timer.cancel();
      estaIniciado = false;
    }
  }

  String formatearTiempo(){
      Duration duration = Duration(microseconds: this.milisegundos);
      String dosValores(int valor){
        return valor >=10 ? "$valor" :"0$valor";

      }
      String horas = dosValores(duration.inHours);
      String minutos = dosValores(duration.inMinutes.remainder(60));
      String segundos = dosValores(duration.inSeconds.remainder(60));
      String milisegundos = dosValores(duration.inMilliseconds.remainder(1000));
      return "$horas:$minutos: $segundos: $milisegundos";
    }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: Colors.blue, size: 60),
          SizedBox(width: 10),
          Text(
              formatearTiempo(),
              style: TextStyle(fontSize: 50),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            //SizedBox(height: 150),
            FloatingActionButton(onPressed: (){
                iniciarCronometro();
        },
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            child: Icon(Icons.timer),
            ),
            //SizedBox(height: 16, width: 30,),
            FloatingActionButton(onPressed: (){
                detenerCronometro();
        },
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.pause),
              ),
        ],)
        
      ],
    );
  }
}