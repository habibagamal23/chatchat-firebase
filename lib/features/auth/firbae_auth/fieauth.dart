import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> createUser() async {
    User? user = auth.currentUser;

    if (user == null) {
      print("No user is currently signed in.");
      return;
    }

    ChatUser chatUser = ChatUser(
      id: user.uid,
      name: user.displayName ?? "",
      email: user.email ?? "",
      about: "Hello, I'm new user",
      createdAt: DateTime.now().toString(),
      lastActivated: DateTime.now().toString(),
      pushToken: "",
      online: false,
    );

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(chatUser.toJson());

      print("User data saved successfully!");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }
}
