import 'package:flutter/material.dart';

class ReuseableTextFelid extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const ReuseableTextFelid({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
      ),
      validator: validator,
    );
  }
}
