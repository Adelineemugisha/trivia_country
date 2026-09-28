import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/game_controller.dart';
import 'screens/flag_trivia_screen.dart';

void main() {
  runApp(const CountryTriviaApp());
}

class CountryTriviaApp extends StatelessWidget {
  const CountryTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController()..initialize(),
      child: MaterialApp(
        title: 'Country Flag Trivia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FlagTriviaScreen(),
      ),
    );
  }
}
