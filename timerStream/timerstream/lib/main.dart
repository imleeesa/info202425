import 'package:flutter/material.dart';
import 'package:timerstream/page/countdown_page.dart';  // Importa CountdownPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer',  // Modifica il titolo dell'applicazione
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Modifica il tema dell'applicazione
      ),
      home: CountdownPage(), // Imposta CountdownPage come home page
    );
  }
}