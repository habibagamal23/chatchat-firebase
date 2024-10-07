import 'package:chatchat/features/login/ui/widgets/emailandpassweord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatchat/features/login/ui/widgets/donthaveacc.dart';
import '../../../core/widgets/button_app.dart';
import '../logic/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 10),
                Text(
                  'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    const EmailAndPassword(),

                    SizedBox(height: 10),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
                        onTap: () {
                          // Handle forgot password logic here
                          print('Forgot Password tapped');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge, // Correct theme usage
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Login Button
                    AppTextButton(
                        buttonText: "Login",
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white),
                        // Use theme styles for consistency
                        onPressed: () {
                          final formKey = context.read<LoginCubit>().formKey;

                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login();
                          }
                        } // Validate and login

                        ),

                    SizedBox(height: 20),
                    // Add spacing before "Don't Have an Account"

                    // "Don't have an account" Text
                    const DontHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
