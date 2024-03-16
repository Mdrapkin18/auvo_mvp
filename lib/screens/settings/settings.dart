import 'package:auvo_mvp/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final int index;
  const SettingsPage({super.key, required int this.index});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account/Profile'),
              onTap: () {
                // Implement navigation or functionality for Account/Profile
                print('Account/Profile tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Implement navigation or functionality for Notifications
                print('Notifications tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text('Users'),
              onTap: () {
                // Implement navigation or functionality for Users
                print('Users tapped');
              },
            ),
          ],
        ).toList(),
      ),
      bottomNavigationBar: BottomNavBar(indexfrompage: widget.index),
    );
  }
}
