import 'package:app_devfest/cubit/addFiles%20cubit/addFilesCubit.dart';
import 'package:app_devfest/cubit/addFiles%20cubit/addFilesState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/components/uploadFilesCard.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddFiles extends StatelessWidget {
  VoidCallback stepContinue;
  VoidCallback stepCancel;
  int currentStep;
  int stepsLength;

  AddFiles({
    super.key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFilesCubit, AddFilesState>(
      listener: (context, state) {
        if (state is AddFilesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is AddFilesSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files uploaded successfully")),
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
              const UploadCard(
                title: "Upload drive's license",
                subtitle: "Please upload your valid driver's license",
                drgaFile:
                    'Drag your file(s) or browse\nMax 10 MB files are allowed',
                fileName: 'drive License.jpg',
                fileSize: '500kb',
              ),
              const SizedBox(height: 24),
              const UploadCard(
                title: 'Upload vehicle registration (Carte Grise)',
                subtitle: "Please upload your valid driver's license",
                drgaFile:
                    "Drag your file(s) or browse\nMax 10 MB files are allowed",
                fileName: 'Carte Grise.jpg',
                fileSize: '500kb',
              ),
              const SizedBox(height: 24),
              const UploadCard(
                title: 'Upload vehicle registration (Carte Grise)',
                subtitle: "Please upload your valid driver's license",
                drgaFile:
                    'Drag your file(s) or browse\nMax 10 MB files are allowed',
                fileName: 'authorization.jpg',
                fileSize: '500kb',
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
