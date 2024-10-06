import 'package:chatchat/features/auth/login.dart';
import 'package:chatchat/features/home/hom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/notes_home.dart';
import 'textfeild_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    nameController.dispose();

    super.dispose();
  }

  Future<void> createUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is currently signed in.");
      return;
    }
    String? displayName = user.displayName;
    String? email = user.email;
    String uid = user.uid;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name':
            displayName ?? 'No Name', // Fallback in case displayName is null
        'email': email ?? 'No Email', // Fallback in case email is null
        'id': uid, // User's UID
      });

      print("User data saved successfully!");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  void _submitRegistration() async {
    if (formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );

        await userCredential.user!.updateDisplayName(nameController.text);

        await createUser();

        print("User registered and display name updated successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesHome()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
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
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomField(
                      controller: nameController,
                      label: "Name",
                      icon: const Icon(Icons.supervised_user_circle),
                    ),
                    CustomField(
                      controller: emailController,
                      label: "Email",
                      icon: const Icon(Icons.email),
                    ),
                    CustomField(
                      controller: passController,
                      label: "Password",
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
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                            "Already have an account? Login".toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                      ),
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
