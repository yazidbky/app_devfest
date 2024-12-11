import 'package:app_devfest/cubit/addFiles%20cubit/addFilesCubit.dart';
import 'package:app_devfest/cubit/addFiles%20cubit/addFilesState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_devfest/components/uploadFilesCard.dart';

class AddFiles extends StatelessWidget {
  const AddFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddFilesCubit(),
      child: BlocListener<AddFilesCubit, AddFilesState>(
        listener: (context, state) {
          if (state is AddFilesFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AddFilesSuccess) {
            // Navigate to the next screen or show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Files uploaded successfully")),
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
                    child: Image.asset('assets/images/logo2.png'),
                  ),
                ),
                const UploadCard(
                  title: 'Upload drive’s license',
                  subtitle: 'Please upload your valid driver’s license',
                  drgaFile:
                      'Drag your file(s) or browse\nMax 10 MB files are allowed',
                  fileName: 'drive License.jpg',
                  fileSize: '500kb',
                ),
                const SizedBox(
                  height: 50,
                ),
                const UploadCard(
                  title: 'Upload vehicle registration (Carte Grise)',
                  subtitle: 'Please upload your valid driver’s license',
                  drgaFile:
                      'Drag your file(s) or browse\nMax 10 MB files are allowed',
                  fileName: 'Carte Grise.jpg',
                  fileSize: '500kb',
                ),
                const SizedBox(
                  height: 50,
                ),
                const UploadCard(
                  title: 'Upload vehicle registration (Carte Grise)',
                  subtitle: 'Please upload your valid driver’s license',
                  drgaFile:
                      'Drag your file(s) or browse\nMax 10 MB files are allowed',
                  fileName: 'authorization.jpg',
                  fileSize: '500kb',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      // Replace this with the actual list of files the user selects
                      List<String> files = [
                        'drive License.jpg',
                        'Carte Grise.jpg',
                        'authorization.jpg'
                      ];
                      context.read<AddFilesCubit>().uploadFiles(files);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    color: const Color(0xFF394496),
                    child: BlocBuilder<AddFilesCubit, AddFilesState>(
                      builder: (context, state) {
                        if (state is AddFilesLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
