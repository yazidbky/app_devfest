import 'package:app_devfest/components/customPaint.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadCard extends StatefulWidget {
  final String title, subtitle, dragFile;
  final ValueChanged<List<File>> onFilesSelected; // Changed to List<File>

  const UploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dragFile,
    required this.onFilesSelected, // Changed parameter name
  });

  @override
  State<UploadCard> createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  List<File> _selectedFiles = []; // Changed to List<File>

  Future<void> _pickFiles() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> files = await picker.pickMultipleMedia(
        imageQuality: 85,
      );

      if (files.isNotEmpty) {
        List<File> newFiles = files.map((file) => File(file.path)).toList();
        setState(() {
          _selectedFiles.addAll(newFiles);
        });
        widget.onFilesSelected(_selectedFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick files: ${e.toString()}")),
      );
    }
  }

  void _removeFile(File file) {
    setState(() {
      _selectedFiles.remove(file);
    });
    widget.onFilesSelected(_selectedFiles);
  }

  void _clearAllFiles() {
    setState(() {
      _selectedFiles.clear();
    });
    widget.onFilesSelected(_selectedFiles);
  }

  String _getFileSizeString(File file) {
    try {
      final bytes = file.lengthSync();
      return "${(bytes / 1024).toStringAsFixed(2)} KB";
    } catch (e) {
      return "Unknown size";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenHeight * 0.7,
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
                      onTap: _pickFiles,
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
                                onPressed: _pickFiles,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF394496),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'Select Files',
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
              if (_selectedFiles.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Files (${_selectedFiles.length})',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: _clearAllFiles,
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...(_selectedFiles.map((file) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file,
                            color: Colors.blue),
                        title: Text(
                          file.path.split('/').last,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _getFileSizeString(file),
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w300),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeFile(file),
                        ),
                      ),
                    ))).toList(),
                const LinearProgressIndicator(
                  value: 1,
                  color: Color(0xFF394496),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
