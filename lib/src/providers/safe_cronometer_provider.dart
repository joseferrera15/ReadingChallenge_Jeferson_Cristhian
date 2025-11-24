import 'package:flutter/material.dart';

class SafeCronometer extends StatefulWidget {
  const SafeCronometer({super.key});

  @override
  State<SafeCronometer> createState() => _SafeCronometerState();
}

class _SafeCronometerState extends State<SafeCronometer> {
  int _seconds = 0;
  bool _isRunning = false;



  void _startTimer() {
    
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      _updateTimer();
    }
  }

  void _updateTimer() {
    if (!_isRunning) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_isRunning) return;
      setState(() {
        _seconds++;
      });
      _updateTimer();
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  String _formatTime() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer, size: 60, color: Colors.blue),
        const SizedBox(height: 10),
        Text(
          _formatTime(),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _isRunning ? null : _startTimer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: _isRunning ? _pauseTimer : null,
              icon: const Icon(Icons.pause),
              label: const Text('Pausar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: _resetTimer,
              icon: const Icon(Icons.stop),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }
}