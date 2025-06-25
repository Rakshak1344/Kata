import 'package:flutter/material.dart';
import 'package:kata/features/calculator/extensions/buildcontext_extension.dart';
import 'package:kata/features/calculator/services/calculator.dart';
import 'package:kata/features/calculator/utils/delimiters.dart';
import 'package:kata/utils/keys.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String outputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kata Calculator'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 22),
              buildInputTextField(),
              SizedBox(height: 12),
              Wrap(
                children: Consts.delimiters.map(buildDelimiterButton).toList(),
              ),
              SizedBox(height: 22),
              buildCalculateButton(),
              SizedBox(height: 22),
              buildResultText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultText(BuildContext context) {
    return Text(
      key: K.calculator.calculationResultText,
      outputValue,
      style: Theme.of(context).textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget buildCalculateButton() {
    return ElevatedButton(
      key: K.calculator.calculateButton,
      onPressed: _onCalculateTap,
      child: Text("Calculate"),
    );
  }

  Widget buildInputTextField() {
    return TextField(
      key: K.calculator.textField,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        label: Center(child: Text("Enter kata numbers to add")),
        hintText: 'e.g. 1, 2, 3',
      ),
    );
  }

  Widget buildDelimiterButton(String delimiter) {
    return Padding(
      key: K.calculator.delimiterButton(delimiter),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: OutlinedButton(
        onPressed: () {
          _insertDelimiter(delimiter);
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Text(delimiter),
      ),
    );
  }

  void _onCalculateTap() {
    if (_controller.text.isEmpty) {
      context.showSnackBar('Please enter a value');
      return;
    }

    try {
      final calculator = Calculator();
      final result = calculator.add(_controller.text);
      setState(() => outputValue = 'Result: $result');
    } catch (e) {
      setState(() => outputValue = e.toString());
    }
  }

  void _insertDelimiter(String delimiter) {
    final text = _controller.text;
    final selection = _controller.selection;

    // Ensure field is focused
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    if (!selection.isValid || !selection.isCollapsed) {
      final newText = text + delimiter;

      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      return;
    }

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      delimiter,
    );

    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + delimiter.length,
      ),
      composing: TextRange.empty,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
