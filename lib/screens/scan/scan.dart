import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parku/screens/scan/confirm.dart';



class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? controller;
  final textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);

  bool isDetecting = false;
  bool isNavigated = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      detectText();
    });

    setState(() {});
  }

  String extractNumberPlate(String text) {
    final regExp =
    RegExp(r'[A-Z]{2}\s?\d{1,2}\s?[A-Z]{1,3}\s?\d{4}');
    final match = regExp.firstMatch(text.toUpperCase());

    if (match != null) {
      return match.group(0)!.replaceAll(" ", "");
    }
    return "NAN";
  }

  Future<void> detectText() async {
    if (isDetecting || isNavigated || controller == null) return;

    isDetecting = true;

    try {
      final file = await controller!.takePicture();

      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText =
      await textRecognizer.processImage(inputImage);

      final plate = extractNumberPlate(recognizedText.text);

      if (plate != "NAN" && mounted) {
        isNavigated = true;

        timer?.cancel();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmPage(
              numberPlate: plate,
              imageFile: File(file.path),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    isDetecting = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    textRecognizer.close();
    super.dispose();
  }


  Widget buildOverlay() {
    return Stack(
      children: [
        Container(color: Colors.black.withOpacity(0.5)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Container(
              width: 260,
              height: 460,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Number Plate"),
      ),
      body: Stack(
        children: [

          CameraPreview(controller!),


          buildOverlay(),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap: () async {

                    timer?.cancel();

                    final picker = ImagePicker();
                    final file =
                    await picker.pickImage(source: ImageSource.gallery);

                    if (file != null) {
                      processImage(file.path);
                    }
                  },
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.photo, color: Colors.white),
                  ),
                ),


                GestureDetector(
                  onTap: () async {
                    final file = await controller!.takePicture();
                    processImage(file.path);
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:Colors.red
                          ),),
                    ),
                  ),
                ),

                // ❌ Close
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processImage(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);
      final recognizedText =
      await textRecognizer.processImage(inputImage);

      final plate = extractNumberPlate(recognizedText.text);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmPage(
            numberPlate: plate,
            imageFile: File(path),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}