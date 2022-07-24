import 'package:flutter/material.dart';

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  labelStyle: const TextStyle(color: Colors.purple),
  hintStyle: TextStyle(color: Colors.deepPurpleAccent.withOpacity(0.5)),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purple, width: 1),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
    borderRadius: BorderRadius.circular(25),
  ),
);

// L39
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
