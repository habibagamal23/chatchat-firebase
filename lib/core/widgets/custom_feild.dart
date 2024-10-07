import 'package:flutter/material.dart';
import '../utils/styles.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final FormFieldValidator<String> validator;
  final bool isFilled;
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.isObscureText = false,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.isFilled = true,
  });

  InputBorder _buildInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.3),
      borderRadius: BorderRadius.circular(16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        focusedBorder: _buildInputBorder(ColorsManager.input),
        enabledBorder: _buildInputBorder(ColorsManager.lightblue),
        errorBorder: _buildInputBorder(Colors.red),
        focusedErrorBorder: _buildInputBorder(Colors.red),
        hintStyle: Theme.of(context).textTheme.titleLarge,
        hintText: hintText,
        suffixIcon: suffixIcon,
        fillColor: backgroundColor ?? ColorsManager.input,
        filled: isFilled,
      ),
      obscureText: isObscureText,
      style: Theme.of(context).textTheme.titleLarge,
      validator: validator,
    );
  }
}
