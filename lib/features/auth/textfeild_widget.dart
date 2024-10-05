import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final Icon icon;
  final String label;
  final TextEditingController controller;
  final bool isPass;
  final String? Function(String?)? validator;

  const CustomField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.isPass = false,
    this.validator,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: widget.validator ??
            (value) => value!.isEmpty
                ? "Required"
                : null, // Use custom validator or default
        obscureText: widget.isPass ? obscure : false,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.isPass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off
                        : Icons.visibility, // Toggle icon visibility
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue)),
          labelText: widget.label,
          prefixIcon: widget.icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
