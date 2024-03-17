import 'package:flashcards_quiz/views/flashcard_screen.dart';
import 'package:flashcards_quiz/views/home_screen.dart';
import 'package:flashcards_quiz/views/login_screen.dart';
import 'package:flashcards_quiz/views/quiz_screen.dart';
import 'package:flashcards_quiz/views/results_screen.dart';
import 'package:flashcards_quiz/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MyApp(),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Riddles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/home_screen': (context) => const HomePage(),
        '/login_screen': (context) => LoginPage(),
      },
    );
  }
}
