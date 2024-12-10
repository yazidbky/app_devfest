import 'package:app_devfest/components/CustomTextField.dart';
import 'package:app_devfest/components/CustomTextFieldPassword.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistreScreen extends StatefulWidget {
  const RegistreScreen({super.key});

  @override
  State<RegistreScreen> createState() => _RegistreScreenState();
}

class _RegistreScreenState extends State<RegistreScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isChecked = false; // State for the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Center(child: Image.asset('assets/images/pattern.png')),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Email TextField
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  CustomTextField(
                    passwordController: fullNameController,
                    hintText: 'Enter Your Full Name',
                    text: 'Full Name',
                  ),
                  CustomTextField(
                    passwordController: emailController,
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

                  // Checkbox with Text
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xFF394496),
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
                  SizedBox(
                    height: 15,
                  ),

                  // Login Button
                  MaterialButton(
                    onPressed: () {
                      if (isChecked) {
                        // Proceed with form submission
                      } else {
                        // Show a message to accept terms
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior:
                                SnackBarBehavior.floating, // Makes it floating
                            margin: const EdgeInsets.all(
                                16), // Adds margin around the SnackBar
                            content: const Text(
                                "Please accept the terms and conditions."),
                            // Optional: customize background color
                          ),
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    color: const Color(0xFF394496),
                    child: Text('Continue',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),

                  // Register Button (Navigate to Register Screen)
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
