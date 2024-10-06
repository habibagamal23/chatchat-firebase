import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NotesHome> {
  final TextEditingController noteController = TextEditingController();
  final User? currentUser =
      FirebaseAuth.instance.currentUser; // Get current user

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // Function to delete a note
  Future<void> _deleteNote(String docId) async {
    await FirebaseFirestore.instance.collection('notes').doc(docId).delete();
  }

  // Function to add a new note
  Future<void> _addNote(String noteText, bool isImportant) async {
    if (currentUser == null) {
      print("No user is currently signed in.");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('notes').add({
        'text': noteText, // The note content
        'userId': currentUser!.uid, // The UID of the current user
        'isImportant': isImportant, // Is the note important
      });

      Navigator.pop(context); // Close the bottom sheet after adding the note
    } catch (e) {
      print("Failed to add note: $e");
    }
  }

  // Function to update an existing note
  Future<void> _updateNote(
      String docId, String newText, bool isImportant) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(docId).update({
        'text': newText,
        'isImportant': isImportant,
      });
      print("Note updated successfully.");
    } catch (e) {
      print("Failed to update note: $e");
    }
  }

  // Show the bottom sheet to add a new note
  void _showAddNoteSheet() {
    bool isImportant = false; // Default value for the checkbox

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Enter Note',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isImportant,
                    onChanged: (value) {
                      setState(() {
                        isImportant = value!;
                      });
                    },
                  ),
                  const Text("Mark as Important"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  String noteText = noteController.text;
                  if (noteText.isNotEmpty) {
                    _addNote(
                        noteText, isImportant); // Pass the importance status
                    noteController.clear();
                  }
                },
                child: const Text('Add Note'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show the bottom sheet to edit an existing note
  void _showEditNoteSheet(
      String docId, String currentText, bool currentIsImportant) {
    bool isImportant = currentIsImportant;
    TextEditingController editNoteController =
        TextEditingController(text: currentText);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNoteController,
                decoration: const InputDecoration(
                  labelText: 'Edit Note',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isImportant,
                    onChanged: (value) {
                      setState(() {
                        isImportant = value!;
                      });
                    },
                  ),
                  const Text("Mark as Important"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  String newNoteText = editNoteController.text;
                  if (newNoteText.isNotEmpty) {
                    _updateNote(docId, newNoteText,
                        isImportant); // Update note in Firestore
                    Navigator.pop(context); // Close the bottom sheet
                  }
                },
                child: const Text('Update Note'),
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
        title: const Text('My Notes'),
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
      // Use StreamBuilder to listen for real-time updates for the current user's notes
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userId',
                isEqualTo:
                    currentUser!.uid) // Only get notes for the current user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notes'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Notes Added',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          var notes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              bool isImportant = note['isImportant'] ?? false;

              return ListTile(
                title: Text(
                  note['text'] ?? 'No content',
                  style: TextStyle(
                    fontWeight:
                        isImportant ? FontWeight.bold : FontWeight.normal,
                    color: isImportant
                        ? Colors.red
                        : Colors.black, // Highlight important notes
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditNoteSheet(
                          note.id, note['text'], isImportant),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
