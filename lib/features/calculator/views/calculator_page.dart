import 'package:flutter/material.dart';
import 'package:kata/features/calculator/extensions/buildcontext_extension.dart';
import 'package:kata/features/calculator/services/calculator.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  List<String> delimiters = [
    "//",
    "[**]",
    "\\n",
    "//",
    "/t",
    "\$\$",
    "[%%]",
    "(&&)",
  ];
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
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  label: Center(child: Text("Enter kata numbers to add")),
                  // labelText: 'Enter kata numbers to add',
                  hintText: 'e.g. 1, 2, 3',
                ),
              ),
              SizedBox(height: 12),
              Wrap(children: delimiters.map(buildDelimiterButton).toList()),
              SizedBox(height: 22),
              ElevatedButton(
                onPressed: _onCalculateTap,
                child: Text("Calculate"),
              ),
              SizedBox(height: 22),
              Text(
                outputValue,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDelimiterButton(String delimiter) {
    return Padding(
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
