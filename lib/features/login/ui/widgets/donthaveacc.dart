
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/routes.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account?',
            style: them.of.largelabel,
          ),
          TextSpan(
            text: ' Sign Up',
            style: them.of.largelabel,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(context ,Routes.signUpScreen);
              },
          ),
        ],
      ),
    );
  }
}