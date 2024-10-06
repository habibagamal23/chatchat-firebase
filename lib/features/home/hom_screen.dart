import 'package:chatchat/features/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async{
             await  FirebaseAuth.instance.signOut();
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(
                   builder: (context) => LoginScreen()),
             );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'No Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
