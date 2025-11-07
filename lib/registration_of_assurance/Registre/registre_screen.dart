import 'package:app_devfest/components/custom_text_field.dart';
import 'package:app_devfest/components/CustomTextFieldPassword.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_cubit.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RegistreScreen extends StatefulWidget {
  VoidCallback stepContinue;
  VoidCallback stepCancel;
  int currentStep;
  int stepsLength;
  RegistreScreen({
    super.key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
  });

  @override
  _RegistreScreenState createState() => _RegistreScreenState();
}

class _RegistreScreenState extends State<RegistreScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController =
      TextEditingController(); // Added for phone
  final TextEditingController addressController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is RegisterSuccess) {
          widget.stepContinue();
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                controller: fullNameController,
                hintText: 'Enter Your Full Name',
                text: 'Full Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: 'Enter Email Address',
                text: 'Email Address',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                hintText: 'Enter Phone Number',
                text: 'Phone Number',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: addressController,
                hintText: 'Enter Your Address',
                text: 'Address',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CustomTextFieldPassword(
                controller: passwordController,
                hintText: 'Enter Password',
                text: 'Create Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomTextFieldPassword(
                controller: confirmPasswordController,
                hintText: 'Enter Password',
                text: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xFF394496),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
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
              const SizedBox(height: 24),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: state is RegisterLoading
                              ? null
                              : () {
                                  context.read<RegisterCubit>().register(
                                        fullName: fullNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                        phone: phoneController.text,
                                        address: addressController.text,
                                        isChecked: isChecked,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF394496),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: state is RegisterLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  widget.currentStep == widget.stepsLength - 1
                                      ? 'Finish'
                                      : 'Continue',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
