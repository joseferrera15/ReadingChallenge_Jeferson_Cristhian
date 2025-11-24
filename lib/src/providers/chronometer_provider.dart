import 'dart:async';
import 'package:flutter/material.dart';

class Cronometer extends StatefulWidget {
  const Cronometer({super.key});

  @override
  State<Cronometer> createState() => _CronometerState();
}

class _CronometerState extends State<Cronometer> {
  int milisegundos = 0;
  bool estaIniciado = false;
  Timer? timer; 

  void iniciarCronometro() {
    if (!estaIniciado) {
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          milisegundos += 100;
        });
      });
      estaIniciado = true;
    }
  }

  void detenerCronometro() {
    if (estaIniciado) {
      timer?.cancel(); 
      estaIniciado = false;
    }
  }

  void reiniciarCronometro() {
    timer?.cancel(); 
    setState(() {
      milisegundos = 0;
      estaIniciado = false;
    });
  }

  String formatearTiempo() {
    Duration duration = Duration(milliseconds: milisegundos);
    String dosValores(int valor) {
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(duration.inHours);
    String minutos = dosValores(duration.inMinutes.remainder(60));
    String segundos = dosValores(duration.inSeconds.remainder(60));
    
    String centesimas = dosValores((milisegundos ~/ 10) % 100);
    return "$horas:$minutos:$segundos:$centesimas";
  }

  @override
  void dispose() {
    timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, color: Colors.blue, size: 60),
        const SizedBox(height: 10),
        Text(
          formatearTiempo(),
          style: const TextStyle(fontSize: 50),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: iniciarCronometro,
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              child: const Icon(Icons.play_arrow), 
            ),
            FloatingActionButton(
              onPressed: detenerCronometro,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: const Icon(Icons.pause),
            ),
            FloatingActionButton(
              onPressed: reiniciarCronometro,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              child: const Icon(Icons.restart_alt),
            ),
          ],
        ),
      ],
    );
  }
}