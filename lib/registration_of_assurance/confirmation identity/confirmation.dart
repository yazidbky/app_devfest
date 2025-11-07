import 'package:app_devfest/cubit/confirmation%20cubit/confirmationCubit.dart';
import 'package:app_devfest/cubit/confirmation%20cubit/confirmationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/components/customButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ignore: must_be_immutable
class IdentityConfirmation extends StatefulWidget {
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
  State<IdentityConfirmation> createState() => _IdentityConfirmationState();
}

class _IdentityConfirmationState extends State<IdentityConfirmation> {
  bool _isVerifying = false;
  bool _isVerified = false;
  String? _uploadedFileName;
  String? _uploadedFileSize;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _simulateVerification() async {
    setState(() {
      _isVerifying = true;
    });

    // Simulate verification process (3-4 seconds)
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isVerifying = false;
      _isVerified = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Identity verification successful!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Auto-advance to next step after a brief delay
    await Future.delayed(const Duration(seconds: 1));
    widget.stepContinue();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final file = File(photo.path);
        final fileSize = await file.length();

        setState(() {
          _selectedImage = file;
          _uploadedFileName =
              "selfie_${DateTime.now().millisecondsSinceEpoch}.jpg";
          _uploadedFileSize = "${(fileSize / 1024).round()}KB";
        });

        // Trigger cubit action
        context.read<IdentityConfirmationCubit>().activateCamera();

        // Start verification process
        _simulateVerification();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error taking photo: $e")),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();

        setState(() {
          _selectedImage = file;
          _uploadedFileName =
              "uploaded_${DateTime.now().millisecondsSinceEpoch}.jpg";
          _uploadedFileSize = "${(fileSize / 1024).round()}KB";
        });

        // Trigger cubit action
        context
            .read<IdentityConfirmationCubit>()
            .uploadFileFromGallery(_uploadedFileName!, _uploadedFileSize!);

        // Start verification process
        _simulateVerification();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IdentityConfirmationCubit, IdentityConfirmationState>(
      listener: (context, state) {
        if (state is IdentityConfirmationFailure) {
          setState(() {
            _isVerifying = false;
            _isVerified = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
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
                  child: _isVerifying
                      ? Column(
                          children: [
                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF394496),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Verifying your identity...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF394496),
                              ),
                            ),
                          ],
                        )
                      : _isVerified
                          ? Column(
                              children: [
                                // Show the uploaded image if available
                                if (_selectedImage != null)
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                const Icon(
                                  Icons.check_circle,
                                  size: 60,
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Identity Verified Successfully!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                          : Image.asset(
                              'assets/images/camera.png',
                              fit: BoxFit.contain,
                              height: 180,
                            ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isVerifying && !_isVerified) ...[
                BlocBuilder<IdentityConfirmationCubit,
                    IdentityConfirmationState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Take Photo',
                      textColor: Colors.white,
                      color: const Color(0xFF394496),
                      borderColor: const Color(0xFF394496),
                      onPressed: _takePhoto,
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Upload From Gallery',
                  textColor: const Color(0xFF394496),
                  borderColor: const Color(0xFF394496),
                  onPressed: _pickFromGallery,
                ),
                const SizedBox(height: 16),
              ],

              // Show uploaded file info if available
              if (_uploadedFileName != null &&
                  _uploadedFileSize != null &&
                  !_isVerifying)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: _isVerified
                            ? Colors.green
                            : const Color(0xFF394496),
                        width: 1,
                      ),
                      color: _isVerified ? Colors.green.withOpacity(0.1) : null,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _isVerified ? Icons.check_circle : Icons.image,
                        color: _isVerified
                            ? Colors.green
                            : const Color(0xFF394496),
                      ),
                      title: Text(
                        _uploadedFileName!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: _isVerified ? Colors.green : null,
                        ),
                      ),
                      subtitle: Text(
                        _uploadedFileSize!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          color: _isVerified ? Colors.green : null,
                        ),
                      ),
                      trailing: _isVerified
                          ? const Icon(
                              Icons.verified,
                              color: Colors.green,
                            )
                          : null,
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              if (!_isVerifying)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: widget.stepCancel,
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
                        onPressed: _isVerified ? widget.stepContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isVerified
                              ? const Color(0xFF394496)
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
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
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
