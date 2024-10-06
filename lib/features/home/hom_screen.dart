import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController categController = TextEditingController();

  @override
  void dispose() {
    categController.dispose();
    super.dispose();
  }

  Future<void> _addcateg(String name) async {
    try {
      await FirebaseFirestore.instance.collection('categoreis').add({
        'name': name,
      });
      Navigator.pop(context);
    } catch (e) {
      print("Failed to add category: $e");
    }
  }

  void _showAddMessageSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categController,
                decoration: const InputDecoration(
                  labelText: 'Enter category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String categText = categController.text;
                  if (categText.isNotEmpty) {
                    _addcateg(categText);
                    categController.clear();
                  }
                },
                child: const Text('Add catogry'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      // Use StreamBuilder to listen for real-time updates from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categoreis').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading catogry'));
          }
          // Check if the data is available and the snapshot contains data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No category Added',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          var categorys = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categorys.length,
            itemBuilder: (context, index) {
              var category = categorys[index];
              return ListTile(
                title: Text(category['name'] ?? 'No content'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMessageSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
