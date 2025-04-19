import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputComponent extends StatefulWidget {
  const InputComponent({
    super.key,
    required this.text,
    required this.textInputControl,
  });
  final String text;
  final TextEditingController textInputControl;

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 7,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text),
        TextField(
          controller: widget.textInputControl,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: widget.text.split(" ")[0],
          ),
        ),
      ],
    );
  }
}
