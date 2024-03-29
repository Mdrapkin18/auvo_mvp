import 'package:flutter/material.dart';

class CustomExpandableCard extends StatelessWidget {
  final String title;
  final int index;

  const CustomExpandableCard({
    Key? key,
    required this.title,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              // Adjust the icon size based on your design requirements
              size: MediaQuery.of(context).size.height * .125,
            ),
            Text(title),
            SizedBox(height: 5),
          ],
        ),
        children: [
          Container(
            height: 100, // Adjust the container height as needed
            child: ListView.builder(
              // Adjust itemCount based on how many items you want in the list
              itemCount: 5, // Example item count for demonstration
              itemBuilder: (context, itemIndex) {
                return ListTile(
                  title: Text('Item $itemIndex in $title'),
                  subtitle: Text('Details for item $itemIndex'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
