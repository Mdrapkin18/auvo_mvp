import 'dart:io';

import 'package:auvo_mvp/widgets/reusable_camera_widget.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DocumentSide { front, back, review }

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  DocumentSide _captureState = DocumentSide.front;
  String? _frontImagePath;
  String? _backImagePath;
  Uint8List? _frontImageBytes;
  Uint8List? _backImageBytes;

  var snackBar = SnackBar(
    content: Text('Successfully Uploaded!'),
  );
  final imageRef = FirebaseStorage.instance.ref('images');

  void _captureImage(DocumentSide side) async {
    final imagePath = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              title: Text(
                  'Capture ${side == DocumentSide.front ? 'Front' : 'Back'} Side')),
          body: ReusableCameraWidget(camera: widget.cameras.first),
        ),
      ),
    );

    if (imagePath != null) {
      if (kIsWeb) {
        if (side == DocumentSide.front) {
          _frontImagePath = imagePath;
          print('web');
          final bytes = await File(_frontImagePath!).readAsBytes();
          setState(() => _frontImageBytes = bytes);
          _captureState = DocumentSide.back;
        } else {
          _frontImagePath = imagePath;
          final bytes = await File(_backImagePath!).readAsBytes();
          setState(() => _backImageBytes = bytes);
          _captureState = DocumentSide.review;
        }
      } else {
        setState(() {
          if (side == DocumentSide.front) {
            print('not web');
            _frontImagePath = imagePath;
            if (_backImagePath == null) {
              _captureState = DocumentSide.back;
            } else {
              _captureState = DocumentSide.review;
            }
          } else {
            _backImagePath = imagePath;
            _captureState = DocumentSide.review;
          }
        });
      }
    }
  }

  Widget _buildReviewPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_frontImagePath != null && kIsWeb)
          Image.memory(_frontImageBytes!,
              height: MediaQuery.of(context).size.height * .35),
        if (_backImagePath != null && kIsWeb)
          Image.memory(_backImageBytes!,
              height: MediaQuery.of(context).size.height * .35),
        if (_frontImagePath != null)
          Image.file(File(_frontImagePath!),
              height: MediaQuery.of(context).size.height * .35),
        if (_backImagePath != null && !kIsWeb)
          Image.file(File(_backImagePath!),
              height: MediaQuery.of(context).size.height * .35),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _captureImage(DocumentSide.front),
              child: Text('Retake Front'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _captureImage(DocumentSide.back),
              child: Text('Retake Back'),
            )
          ],
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement your submission logic here

            String time = DateTime.now().millisecondsSinceEpoch.toString();

            imageRef.child('${time}_front.jpg').putFile(File(_frontImagePath!));
            imageRef.child('${time}_back.jpg').putFile(File(_backImagePath!));

            print('Submitted images to Firebase');
            print('Time: $time');

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Capture')),
      body: _captureState == DocumentSide.review
          ? _buildReviewPage()
          : Center(
              child: ElevatedButton(
                onPressed: () => _captureImage(_captureState),
                child: Text(_captureState == DocumentSide.front
                    ? 'Capture Front Side'
                    : 'Capture Back Side'),
              ),
            ),
    );
  }
}
