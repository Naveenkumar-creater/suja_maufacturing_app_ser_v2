import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String?)? validation;
  final String hintText;
  final Function()? onEditingComplete;

  const CustomNumField({
    required this.controller,
    this.focusNode,
    this.validation,
    required this.hintText,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number, // Only allows numeric input
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Restricts to digits only
      ],
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: 40, maxWidth: 200),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
          labelStyle: const TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1))),
      onEditingComplete: onEditingComplete,
      validator: validation as String? Function(String?)?,
    );
  }
}
