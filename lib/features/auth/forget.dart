import 'package:flutter/material.dart';
import 'textfeild_widget.dart';
class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _submitResetPassword() {
    if (formKey.currentState!.validate()) {
      print('Email: ${emailController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Reset Password,",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Please Enter Your Email",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: CustomField(
                  controller: emailController,
                  label: "Email",
                  icon: const Icon(Icons.email), // Assuming Iconsax is defined
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitResetPassword,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      Colors.blue,
                  padding: const EdgeInsets.all(16),
                ),
                child: Center(
                  child: Text(
                    "Send Email".toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
