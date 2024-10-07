import 'package:firebase_auth/firebase_auth.dart';

import '../../features/login/model/login_model.dart';

class FirebaseService {
  Future<User?> login(LoginRequestBody loginRequest) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginRequest.email,
        password: loginRequest.password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
