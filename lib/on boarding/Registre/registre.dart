import 'package:app_devfest/cubit/Registre%20Cubit/registre_cubit.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistreScreen extends StatelessWidget {
  const RegistreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the RegisterCubit
    final registerCubit = context.read<RegisterCubit>();

    // TextEditingControllers to capture user input
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful!')),
            );
            // Navigate to login or home page after success
            Navigator.pop(context); // For example, go back to login screen
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    // Validate email and password
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    // Trigger the registration process
                    registerCubit.register(email, password);
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to login screen
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
