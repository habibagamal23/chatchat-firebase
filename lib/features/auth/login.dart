import 'package:chatchat/features/auth/forget.dart';
import 'package:chatchat/features/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/hom_screen.dart';
import '../home/notes_home.dart';
import 'textfeild_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                "Welcome Back,",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomField(
                      controller: emailController,
                      label: "Email",
                      icon: const Icon(Icons.email),
                    ),
                    CustomField(
                      controller: passwordController,
                      label: "Password",
                      icon: const Icon(Icons.lock),
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          child: const Text("Forgot Password?"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetScreen()),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            print("Login successful");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesHome()),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Center(
                        child: Text(
                          "Login".toUpperCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Create Account".toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          )),
                    ),
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
