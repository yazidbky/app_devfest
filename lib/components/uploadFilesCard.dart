import 'package:app_devfest/components/customPaint.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadCard extends StatelessWidget {
  final String title, subtitle, drgaFile, fileName, fileSize;
  const UploadCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.drgaFile,
      required this.fileName,
      required this.fileSize});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenHeight * 0.7, // Increased height
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
              // Dashed border container inside
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: CustomPaint(
                    painter: DashedBorderPainter(),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.blue,
                            ),
                            Text(drgaFile),
                          ],
                        )),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Only support .jpg, .png and .svg and zip files',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(
                  fileName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(fileSize,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w300)),
              ),
              const LinearProgressIndicator(
                value: 1,
                color: Color(0xFF394496),
              )
            ],
          ),
        ),
      ),
    );
  }
}
