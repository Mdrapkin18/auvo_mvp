import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({super.key, required int this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
