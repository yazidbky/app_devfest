import 'package:app_devfest/cubit/confirmation%20cubit/confirmationCubit.dart';
import 'package:app_devfest/cubit/confirmation%20cubit/confirmationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/components/customButton.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class IdentityConfirmation extends StatelessWidget {
  VoidCallback stepContinue;
  VoidCallback stepCancel;
  int currentStep;
  int stepsLength;

  IdentityConfirmation({
    super.key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<IdentityConfirmationCubit, IdentityConfirmationState>(
      listener: (context, state) {
        if (state is IdentityConfirmationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is IdentityConfirmationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("File uploaded: ${state.fileName}, ${state.fileSize}"),
            ),
          );
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "To verify your identity\nplease take a clear selfie while holding your driver's license next to your face.\nEnsure both your face and the license details are fully visible and in focus",
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    'assets/images/camera.png',
                    fit: BoxFit.contain,
                    height: 180,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<IdentityConfirmationCubit, IdentityConfirmationState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Continue',
                    textColor: Colors.white,
                    color: const Color(0xFF394496),
                    borderColor: const Color(0xFF394496),
                    onPressed: () {
                      if (state is IdentityConfirmationLoading) {
                        return;
                      }
                      context
                          .read<IdentityConfirmationCubit>()
                          .activateCamera();
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Upload From Gallery',
                textColor: const Color(0xFF394496),
                borderColor: const Color(0xFF394496),
                onPressed: () {
                  context
                      .read<IdentityConfirmationCubit>()
                      .uploadFileFromGallery("fileName.jpg", "500Kb");
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border:
                        Border.all(color: const Color(0xFF394496), width: 1),
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/camera.png'),
                    title: Text(
                      'fileName',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '500Kb',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: stepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: stepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF394496),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        currentStep == stepsLength - 1 ? 'Finish' : 'Continue',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
