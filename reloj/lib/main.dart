import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reloj',
      theme: ThemeData.dark(),
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late String timeString;
  bool isDayTime = true; // Inicialización directa de isDayTime

  @override
  void initState() {
    super.initState();
    timeString = _getCurrentTime();
    isDayTime = _checkDayTime(); // Inicializar isDayTime en initState()
    Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  // Obtener la hora actual en formato HH:mm:ss
  String _getCurrentTime() {
    final now = DateTime.now();
    int hour = now.hour % 12;
    String ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} $ampm';
  }

  // Verificar si es de día o de noche
  bool _checkDayTime() {
    final now = DateTime.now();
    return now.hour >= 6 && now.hour < 18; // De 6 AM a 6 PM es de día
  }

  // Actualizar el tiempo cada segundo
  void _updateTime(Timer timer) {
    setState(() {
      timeString = _getCurrentTime();
      isDayTime = _checkDayTime(); // Verificar si es día o noche
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDayTime
                ? [Colors.blueAccent, Colors.yellowAccent]
                : [Colors.indigo, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500), // Animación de 500ms
                child: Icon(
                  isDayTime ? Icons.wb_sunny : Icons.nightlight_round,
                  key: ValueKey<bool>(isDayTime), // Cambia el icono según el tiempo del día
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  timeString,
                  key: ValueKey<String>(timeString), // Asegura que la animación funcione correctamente
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.7),
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
