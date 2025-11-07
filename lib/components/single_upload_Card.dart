import 'package:app_devfest/components/customPaint.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SingleUploadCard extends StatefulWidget {
  final String title, subtitle, dragFile;
  final ValueChanged<File?> onFileSelected;

  const SingleUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dragFile,
    required this.onFileSelected,
  });

  @override
  State<SingleUploadCard> createState() => _SingleUploadCardState();
}

class _SingleUploadCardState extends State<SingleUploadCard> {
  File? _selectedFile;
  String _fileName = "";
  String _fileSize = "";

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() {
          _selectedFile = File(file.path);
          _fileName = file.name;
          file.length().then((length) {
            setState(() {
              _fileSize = "${(length / 1024).toStringAsFixed(2)} KB";
            });
          });
        });
        widget.onFileSelected(_selectedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick file: ${e.toString()}")),
      );
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _fileName = "";
      _fileSize = "";
    });
    widget.onFileSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenHeight * 0.7, // Smaller height for single file
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
                widget.title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.subtitle,
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
                      onTap: _pickFile,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.blue,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.dragFile,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _pickFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF394496),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'Select File',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Supported formats: .jpg, .png, .pdf',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                ),
              ),
              if (_selectedFile != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.insert_drive_file, color: Colors.blue),
                    title: Text(
                      _fileName,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _fileSize,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: _removeFile,
                    ),
                  ),
                ),
              if (_selectedFile != null)
                const LinearProgressIndicator(
                  value: 1,
                  color: Color(0xFF394496),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
