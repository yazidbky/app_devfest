import 'package:app_devfest/components/CustomTextField.dart';
import 'package:app_devfest/components/CustomTextFieldPassword.dart';
import 'package:app_devfest/home/home.dart';
import 'package:app_devfest/registration%20of%20assurance/Registre/registreScreen.dart'; // Import necessary screens
import 'package:app_devfest/registration%20of%20assurance/add%20files/addFiles.dart';
import 'package:app_devfest/registration%20of%20assurance/confirmation%20identity/confirmation.dart';
import 'package:app_devfest/registration%20of%20assurance/plans/plans.dart';
import 'package:app_devfest/stepper/stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
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
                      child: Image.asset('assets/images/logo2.png'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Login",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Use your email and password to login",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Enter Your Email',
                    text: 'Email',
                  ),
                  CustomTextFieldPassword(
                    passwordController: passwordController,
                    hintText: 'Enter Your Full Name',
                    text: 'Full Name',
                    obscureText: true,
                  ),

                  // Login Button
                  MaterialButton(
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter both email and password')),
                        );
                        return;
                      }

                      // Perform login logic here (e.g., check credentials)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Successful!')),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));

                      // Navigate to another screen or perform any other action after login
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    color: Color(0xFF394496),
                    child: Text('Continue',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),

                  // Register Button (Navigate to HorizontalStepper)
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HorizontalStepper(
                                steps: [
                                  RegistreScreen(), // Step 1
                                  AddFiles(), // Step 2
                                  IdentityConfirmation(), // Step 3
                                  Plans(), // Step 4
                                ],
                                onStepTapped: (index) {
                                  print("Tapped on step $index");
                                },
                              ),
                            ));
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
