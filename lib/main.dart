import 'package:flutter/material.dart';

import 'features/calculator/views/calculator_page.dart';

void main() {
  runApp(const KataApp());
}

class KataApp extends StatelessWidget {
  const KataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CalculatorPage(),
    );
  }
}
