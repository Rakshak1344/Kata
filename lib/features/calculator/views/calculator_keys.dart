import 'package:flutter/material.dart';

const calculatorKeys = CalculatorKeys();

class CalculatorKeys {
  const CalculatorKeys();

  final Key textField = const Key("calculatorTextField");
  final Key calculateButton = const Key("calculateButton");
  final Key calculationResultText = const Key("calculationResultText");

  Key delimiterButton(String delimiter) => Key("delimiterButton_$delimiter");
}
