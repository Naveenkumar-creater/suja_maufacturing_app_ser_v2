import 'package:flutter/material.dart';

class CustomTextFormfield extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscuringCharacter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String?)? validation;
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormfield(
      {super.key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isObscureText = false,
      this.obscuringCharacter = "*",
      this.prefixIcon,
      this.suffixIcon,
      this.hintText,
      this.validation, this.focusNode, this.onEditingComplete, this.onFieldSubmitted});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return TextFormField(
       focusNode:focusNode ,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted:onFieldSubmitted,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscureText!,
      obscuringCharacter: obscuringCharacter!,
      style: const TextStyle(color: Colors.black38, fontSize: 16),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: height, maxWidth: width),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
           labelStyle: const TextStyle(fontSize: 12),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
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
      validator: validation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
