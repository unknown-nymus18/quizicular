import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  TextEditingController textEditingController;
  String label;
  bool? obscure;
  CustomTextField({
    super.key,
    required this.textEditingController,
    required this.label,
    this.obscure = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(77, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(77, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(174, 0, 0, 0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: widget.label,
        suffixIcon: null,
        labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
      ),
      obscuringCharacter: "*",
      obscureText: widget.obscure!,
      controller: widget.textEditingController,
      style: TextStyle(fontSize: 18),
    );
  }
}
