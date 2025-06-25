import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kata/features/calculator/utils/delimiters.dart';
import 'package:kata/main.dart';
import 'package:kata/utils/keys.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('UI test on calculator page', (WidgetTester tester) async {
    await tester.pumpWidget(const KataApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(K.calculator.textField), '1,2');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(K.calculator.calculateButton));
    await tester.pumpAndSettle();

    expect(find.byKey(K.calculator.calculationResultText), findsOneWidget);
    expect(find.textContaining('Result: 3'), findsOneWidget);
  });

  testWidgets('Calculator should throw error on negative input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KataApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(K.calculator.textField),
      '///(%#),10,-200',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(K.calculator.calculateButton));
    await tester.pumpAndSettle();

    expect(find.byKey(K.calculator.calculationResultText), findsOneWidget);
    expect(
      find.textContaining('Negative number is not allowed: -200'),
      findsOneWidget,
    );
  });

  testWidgets('Calculator should throw error on multiple negative input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KataApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(K.calculator.textField),
      '///(%#),10,-5}-90',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(K.calculator.calculateButton));
    await tester.pumpAndSettle();

    expect(find.byKey(K.calculator.calculationResultText), findsOneWidget);
    expect(
      find.textContaining('Negative numbers are not allowed: -5, -90'),
      findsOneWidget,
    );
  });

  testWidgets('Calculator delimiter(s) button test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KataApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(K.calculator.textField), '5');
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(K.calculator.delimiterButton(Consts.delimiters[0])),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(K.calculator.delimiterButton(Consts.delimiters[1])),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(K.calculator.delimiterButton(Consts.delimiters[2])),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(K.calculator.delimiterButton(Consts.delimiters[3])),
    );
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(
      find.byKey(K.calculator.textField),
    );
    expect(textField.controller?.text, '5//[**]\\n/t');
  });
}
