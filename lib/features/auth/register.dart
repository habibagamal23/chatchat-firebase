import 'package:flutter/material.dart';
import 'textfeild_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void _submitRegistration() async {
    if (formKey.currentState!.validate()) {
      print('Name: ${nameController.text}');
      print('Email: ${emailController.text}');
      print('Phone: ${phoneController.text}');
      print('Password: ${passwordController.text}');
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
              const SizedBox(
                height: 20,
              ),
              Text(
                "Create Your Account,",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Chat App Registration",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomField(
                      controller: nameController,
                      label: "Name",
                      icon: const Icon(Icons.person),
                    ),
                    CustomField(
                      controller: emailController,
                      label: "Email",
                      icon: const Icon(Icons.email),
                    ),
                    CustomField(
                      controller: phoneController,
                      label: "Phone",
                      icon: const Icon(Icons.phone),
                    ),
                    CustomField(
                      controller: passwordController,
                      label: "Password",
                      icon: const Icon(Icons.lock),
                      isPass: true,
                    ),
                    CustomField(
                      controller: passwordConfirmationController,
                      label: "Confirm Password",
                      icon: const Icon(Icons.lock),
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Center(
                        child: Text(
                          "Register".toUpperCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Already have an account? Login".toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
