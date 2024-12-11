import 'package:app_devfest/utils/mainColor.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for kIsWeb

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _imagePicker = ImagePicker();

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0;
  String? _capturedImagePath; // Store the captured image path

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera([int cameraIndex = 0]) async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        print("No cameras available");
        return;
      }

      _cameraController = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.high,
      );

      await _cameraController.initialize();

      setState(() {
        _isCameraInitialized = true;
        _selectedCameraIndex = cameraIndex;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> switchCamera() async {
    final int newIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeCamera(newIndex);
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      final XFile picture = await _cameraController.takePicture();
      setState(() {
        _capturedImagePath = picture.path; // Store the image path
      });
      print("Picture saved at: ${picture.path}");
    } catch (e) {
      print("Error capturing picture: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print("Image picked from gallery: ${image.path}");
      // Handle the image (e.g., display it in the app or upload it)
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? Stack(
            children: [
              // Display camera preview or captured image
              _capturedImagePath == null
                  ? Positioned.fill(
                      child: CameraPreview(_cameraController),
                    )
                  : Positioned.fill(
                      child: kIsWeb
                          ? Image.network(
                              _capturedImagePath!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_capturedImagePath!),
                              fit: BoxFit.cover,
                            ),
                    ),

              // Retake and Send buttons when an image is captured
              if (_capturedImagePath != null)
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              _capturedImagePath = null; // Retake picture
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: mainColor)),
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          color: Colors.white,
                          child: Text('Retake',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: mainColor)),
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          color: mainColor,
                          child: Text('Send',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),

              // Switch Camera Button (bottom left)
              if (_capturedImagePath == null)
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: IconButton(
                    icon: const Icon(Icons.cameraswitch,
                        color: Colors.white, size: 40),
                    onPressed: switchCamera,
                  ),
                ),

              // Take Picture Button (center)
              if (_capturedImagePath == null)
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width / 2 - 30,
                  child: IconButton(
                    icon:
                        const Icon(Icons.circle, color: Colors.white, size: 50),
                    onPressed: takePicture,
                  ),
                ),

              // Back Button
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                left: MediaQuery.of(context).size.width * 0.05,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Image Picker Button (bottom right, only visible if no image is captured)
              if (_capturedImagePath == null)
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: IconButton(
                    icon: const Icon(Icons.photo_library,
                        color: Colors.white, size: 40),
                    onPressed: pickImageFromGallery,
                  ),
                ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
