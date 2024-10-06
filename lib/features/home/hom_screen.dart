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
  final TextEditingController messageController = TextEditingController();
  List messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the screen is loaded
  }

  @override
  void dispose() {
    messageController.dispose(); // Dispose the controller when the widget is destroyed
    super.dispose();
  }

  // Function to fetch messages from Firestore
  Future<void> _fetchMessages() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('messages').get();

      // Clear the current list before adding new messages
      messages.clear();

      // Add fetched documents to the list
      messages.addAll(querySnapshot.docs);

      // Notify the framework that the state has changed
      setState(() {});
    } catch (e) {
      print("Failed to fetch messages: $e");
    }
  }

  Future<void> _addMessage(String messageText) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _fetchMessages();
      Navigator.pop(context);
    } catch (e) {
      print("Failed to add message: $e");
    }
  }

  // Show the bottom sheet to add a new message
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
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Enter Message',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String messageText = messageController.text;
                  if (messageText.isNotEmpty) {
                    _addMessage(messageText); // Add message to Firestore
                    messageController.clear(); // Clear the input field
                  }
                },
                child: const Text('Add Message'),
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
      body: messages.isEmpty
          ? const Center(
        child: Text(
          'No Messages Added',
          style: TextStyle(fontSize: 24),
        ),
      )
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          var message = messages[index];
          return ListTile(
            title: Text(message['text'] ?? 'No content'),
            subtitle: Text(message['timestamp'] != null
                ? message['timestamp'].toDate().toString()
                : 'No timestamp'),
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
