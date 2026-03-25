import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'confirm.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker picker = ImagePicker();
  final TextRecognizer textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);

  bool processing = false;

  // 🔍 Extract Number Plate
  String extractNumberPlate(String text) {
    final regExp =
    RegExp(r'[A-Z]{2}\s?\d{1,2}\s?[A-Z]{1,3}\s?\d{4}');
    final match = regExp.firstMatch(text.toUpperCase());

    if (match != null) {
      return match.group(0)!.replaceAll(" ", "");
    }
    return "NAN";
  }

  // 📸 Camera Capture
  Future<void> scanCamera() async {
    final file = await picker.pickImage(source: ImageSource.camera);

    if (file == null) return;

    processImage(file.path);
  }

  // 🖼️ Gallery Pick
  Future<void> scanGallery() async {
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    processImage(file.path);
  }

  // 🧠 ML Processing
  Future<void> processImage(String path) async {
    setState(() => processing = true);

    try {
      final inputImage = InputImage.fromFilePath(path);
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      String fullText = recognizedText.text;

      String plate = extractNumberPlate(fullText);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmPage(numberPlate: plate),
        ),
      );
    } catch (e) {
      debugPrint("Error: $e");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmPage(numberPlate: "NAN"),
        ),
      );
    }
    setState(() => processing = false);
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Number Plate"),
      ),
      body: Center(
        child: processing
            ? const CircularProgressIndicator()
            : const Text("Tap camera or gallery to scan"),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: scanGallery,
            backgroundColor: Colors.black,
            child: const Icon(Icons.photo, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "camera",
            onPressed: scanCamera,
            backgroundColor: Colors.black,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}