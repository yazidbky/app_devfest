import 'package:app_devfest/cubit/confirmation%20cubit/confirmationCubit.dart';
import 'package:app_devfest/cubit/confirmation%20cubit/confirmationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/components/customButton.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentityConfirmation extends StatelessWidget {
  const IdentityConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IdentityConfirmationCubit(),
      child: BlocListener<IdentityConfirmationCubit, IdentityConfirmationState>(
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
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'To verify your identity\nplease take a clear selfie while holding your driver’s license next to your face.\nEnsure both your face and the license details are fully visible and in focus'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.asset('assets/images/camera.png'),
                  ),
                ),
                BlocBuilder<IdentityConfirmationCubit,
                    IdentityConfirmationState>(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: const Color(0xFF394496), width: 1)),
                    child: ListTile(
                      leading: Image.asset('assets/images/camera.png'),
                      title: Text(
                        'fileName',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('500Kb',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
                BlocBuilder<IdentityConfirmationCubit,
                    IdentityConfirmationState>(
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
                        // Perform the next action after upload or camera activation
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
