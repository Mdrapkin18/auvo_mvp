import 'package:auvo_mvp/screens/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

List<CameraDescription> cameras = [];

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({super.key, required int this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = _cameraController.initialize();
    await availableCameras().then(
      (value) {
        print('first load: $value');
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => CameraPage(cameras: value)));
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void openCamera() async {
    await _initializeControllerFuture;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraPreviewScreen(cameraController: _cameraController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Title Scan Button
            ElevatedButton(
              onPressed: () {
                initializeCamera();
                // Implement Title Scan functionality
              },
              child: Text('Title Scan'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56), // width and height
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Vin Scan Button
            ElevatedButton(
              onPressed: () {
                // Implement Vin Scan functionality
              },
              child: Text('Vin Scan'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56), // width and height
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Plate Scan Button
            ElevatedButton(
              onPressed: () {
                // Implement Plate Scan functionality
              },
              child: Text('Plate Scan'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56), // width and height
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Manual VIN or Plate Button
            ElevatedButton(
              onPressed: () {
                // Implement Manual VIN or Plate functionality
              },
              child: Text('Manual VIN or Plate'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56), // width and height
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // File Upload Button
            ElevatedButton(
              onPressed: () {
                // Implement File Upload functionality
              },
              child: Text('File Upload'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56), // width and height
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(indexfrompage: widget.index),
    );
  }
}

class CameraPreviewScreen extends StatelessWidget {
  final CameraController cameraController;

  const CameraPreviewScreen({Key? key, required this.cameraController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Preview")),
      body: CameraPreview(cameraController),
    );
  }
}
