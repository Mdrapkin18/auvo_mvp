import 'package:auvo_mvp/screens/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Auvo_logo_4k.png',
                width: MediaQuery.of(context).size.width *
                    0.6, // Adjust the size as needed
              ),
              SizedBox(height: 40), // Space between logo and username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20), // Space between username and password field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30), // Space between password and login button
              ElevatedButton(
                onPressed: () {
                  // Implement your login logic here
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              index: 0,
                            )),
                  );
                  print('Login button pressed');
                },
                child: Text('Login', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 50), // Set the button's size
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Add rounded corners
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
