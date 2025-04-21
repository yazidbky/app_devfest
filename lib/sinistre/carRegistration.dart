import 'package:app_devfest/camera/cameraInitilization.dart';
import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/sinistre/accidentsDetails.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CarRegistration extends StatefulWidget {
  const CarRegistration({super.key});

  @override
  State<CarRegistration> createState() => _CarRegistrationState();
}

class _CarRegistrationState extends State<CarRegistration> {
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  onContinuePressed() {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    // Perform your upload or camera activation logic here

    // After operation is complete, reset loading state
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Image.asset('assets/images/logo2.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'please take some pictures of your Sinisters\ntake photos for all the car and the damages\nso we can predict the amout of damage ',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Image.asset('assets/images/camera.png'),
              ),
            ),
            CustomButton(
              text: 'Take A picture',
              textColor: Colors.white,
              color: const Color(0xFF394496),
              borderColor: const Color(0xFF394496),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraPage(),
                    ));
              },
            ),
            CustomButton(
                text: 'Upload From Gallery',
                textColor: const Color(0xFF394496),
                borderColor: const Color(0xFF394496),
                onPressed: pickImageFromGallery),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: const Color(0xFF394496),
                    width: 1,
                  ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: const Color(0xFF394496),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(
                    'fileName',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('fileSize',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w300)),
                ),
              ),
            ),
            CustomButton(
              text: 'Continue',
              textColor: Colors.white,
              color: const Color(0xFF394496),
              borderColor: const Color(0xFF394496),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccidentsDetails(),
                    ));
              },
            ),
            CustomButton(
              text: 'Skip',
              textColor: mainColor,
              borderColor: const Color(0xFF394496),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccidentsDetails(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
