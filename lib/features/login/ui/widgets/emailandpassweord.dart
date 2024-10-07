import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_feild.dart';
import '../../logic/login_cubit.dart';

class EmailAndPassword extends StatelessWidget {
  const EmailAndPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey, // Use formKey from the Cubit
      child: Column(
        children: [
          // Email field
          AppTextFormField(
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            controller: context.read<LoginCubit>().emailController,
          ),

          // Password field using BlocBuilder for visibility state
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              bool isPasswordVisible = false;

              // Check if the current state is for toggling password visibility
              if (state is LoginPasswordVisibilityToggled) {
                isPasswordVisible = state.isPasswordVisible;
              }

              return AppTextFormField(
                controller: context.read<LoginCubit>().passwordController,
                hintText: 'Password',
                isObscureText: !isPasswordVisible, // Use state from Cubit
                suffixIcon: GestureDetector(
                  onTap: () {
                    context
                        .read<LoginCubit>()
                        .togglePasswordVisibility(); // Call Cubit method
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a valid password (at least 6 characters)';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
