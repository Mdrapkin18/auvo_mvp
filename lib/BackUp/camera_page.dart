import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Correctly adds this class as an observer
    requestPermissions();
  }

  void requestPermissions() async {
    print('request sent');
    // Request camera and microphone permissions before initializing the camera.
    await [Permission.camera, Permission.microphone].request().then((value) {
      print('Permissions request granted');
      print('value: $value');
      initCamera(widget.cameras![0]);
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Current state $state');
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('camera controller: ${_cameraController?.value}');
      // Now check if _cameraController is null before using it
      if (_cameraController != null &&
          !_cameraController!.value.isInitialized) {
        print('requesting permission');
        requestPermissions(); // This will reinitialize the camera if needed
      } else {
        initCamera(widget.cameras![0]);
        setState(() {});
      }
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      _cameraController =
          CameraController(cameraDescription, ResolutionPreset.high);
      _initializeControllerFuture = _cameraController?.initialize();
      if (!mounted) return;
      setState(() {
        print('init camera granted');
      });
    } else {
      print('Camera or Microphone permissions not granted');
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      // First, take the picture and get the XFile
      final XFile? picture = await _cameraController?.takePicture();

      if (picture == null) {
        print('No picture taken');
        return;
      }

      // Get the path to the directory where photos are stored
      final Directory extDir =
          await getApplicationDocumentsDirectory(); // Or use getApplicationDocumentsDirectory(), depending on your needs

      // Create a new timestamped file name for the picture
      final String dirPath = '${extDir.path}/Pictures/flutter_camera';
      await Directory(dirPath)
          .create(recursive: true); // Ensure the directory exists
      final String filePath =
          join(dirPath, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Create a File from the XFile path
      final File tempImageFile = File(picture.path);

      // Copy the picture file to the new path
      final File savedImage = await tempImageFile.copy(filePath);

      // Update the UI and state with the new image path
      if (mounted) {
        setState(() {
          imagePath = savedImage.path; // Now this refers to the new file's path
          print('File saved to: $imagePath');
        });
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture')),
      // You must wait until the controller is initialized before displaying the camera preview.
      // Use a FutureBuilder to display a loading spinner until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (imagePath != null) {
              return ImageReviewPage(
                imagePath: imagePath!,
                onRetake: () {
                  setState(() {
                    imagePath =
                        null; // Set back to null to take another picture
                  });
                },
              );
            } else {
              return CameraPreview(_cameraController!);
            }
          }
        },
      ),
      floatingActionButton: imagePath == null
          ? FloatingActionButton(
              onPressed: _takePicture,
              child: Icon(Icons.camera_alt),
            )
          : null,
    );
  }
}

class ImageReviewPage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRetake;

  const ImageReviewPage(
      {Key? key, required this.imagePath, required this.onRetake})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Image.file(File(imagePath)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: onRetake,
              child: Icon(Icons.camera_alt),
            ),
            SizedBox(width: 20), // Add some space
            FloatingActionButton(
              onPressed: () {
                // Code to accept the image and do something with it
                // For now, just pop the current route
                Navigator.pop(context);
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
      ],
    );
  }
}
