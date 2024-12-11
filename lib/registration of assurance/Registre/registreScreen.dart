import 'package:app_devfest/cubit/Registre%20Cubit/registre_cubit.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_devfest/components/CustomTextField.dart';
import 'package:app_devfest/components/CustomTextFieldPassword.dart';

class RegistreScreen extends StatelessWidget {
  const RegistreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isChecked = false;

    return Scaffold(
      body: BlocProvider(
        create: (_) => RegisterCubit(),
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is RegisterSuccess) {
              Navigator.pushReplacementNamed(context,
                  '/home'); // Navigate to the home screen or desired page
            }
          },
          child: Stack(
            children: [
              Center(child: Image.asset('assets/images/pattern.png')),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Image.asset('assets/images/logo2.png')),
                      ),
                      CustomTextField(
                        controller: fullNameController,
                        hintText: 'Enter Your Full Name',
                        text: 'Full Name',
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Enter Email Address',
                        text: 'Email Address',
                      ),
                      CustomTextFieldPassword(
                        passwordController: passwordController,
                        hintText: 'Enter Password',
                        text: 'Create Password',
                        obscureText: true,
                      ),
                      CustomTextFieldPassword(
                        passwordController: confirmPasswordController,
                        hintText: 'Enter Password',
                        text: 'Confirm Password',
                        obscureText: true,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: const Color(0xFF394496),
                            value: isChecked,
                            onChanged: (bool? value) {
                              isChecked = value ?? false;
                            },
                          ),
                          Expanded(
                            child: Text(
                              "I agree to the terms and conditions",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      MaterialButton(
                        onPressed: () {
                          context.read<RegisterCubit>().register(
                                fullName: fullNameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                                isChecked: isChecked,
                              );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        color: const Color(0xFF394496),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
