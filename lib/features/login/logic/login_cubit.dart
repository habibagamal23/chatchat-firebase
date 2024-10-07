import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/network_services/firebase_sevice.dart';
import '../model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseService _firebaseService;

  LoginCubit(this._firebaseService) : super(LoginInitial());


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginPasswordVisibilityToggled(isPasswordVisible));
  }

  // Dispose the controllers if necessary from the UI layer
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  // Login method
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoading());

      try {
        final loginRequest = LoginRequestBody(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = await _firebaseService.login(loginRequest);

        if (user != null) {
          emit(LoginSuccess(user: user));
        } else {
          emit(LoginFailure('Login failed. Please check your credentials.'));
        }
      } catch (e) {
        emit(LoginFailure('Login failed. Error: $e'));
      }
    }
  }
}