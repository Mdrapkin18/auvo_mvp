import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ReusableCameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const ReusableCameraWidget({Key? key, required this.camera})
      : super(key: key);

  @override
  _ReusableCameraWidgetState createState() => _ReusableCameraWidgetState();
}

class _ReusableCameraWidgetState extends State<ReusableCameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();
                      Navigator.of(context).pop(image.path);
                    } catch (e) {
                      print(e); // Handle the error
                    }
                  },
                  child: Icon(Icons.camera_alt),
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
