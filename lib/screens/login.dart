import 'package:auvo_mvp/screens/create_account_screen.dart';
import 'package:auvo_mvp/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _rememberMe = false;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    // Try to read the user email from secure storage if "Remember Me" was checked
    String? userEmail = await _storage.read(key: 'userEmail');
    bool? rememberMe = await _storage.read(key: 'rememberMe') == 'true';

    if (userEmail != null && rememberMe) {
      setState(() {
        _usernameController.text = userEmail;
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (_rememberMe) {
        await _storage.write(
            key: 'userEmail', value: _usernameController.text.trim());
        await _storage.write(key: 'rememberMe', value: 'true');
      } else {
        await _storage.delete(key: 'userEmail');
        await _storage.write(key: 'rememberMe', value: 'false');
      }

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(index: 0)));
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _resetPassword() async {
    if (_usernameController.text.trim().isEmpty) {
      _showErrorDialog("Please enter your email to reset your password.");
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(
          email: _usernameController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password reset email sent."),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      _showErrorDialog("Failed to send password reset email.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

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
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              TextButton(
                onPressed: _resetPassword,
                child: Text('Forgot Password?'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountScreen())),
                child: Text('Create Account'),
              ),
              TextButton(
                onPressed: () {
                  _auth.signInWithEmailAndPassword(
                      email: 'test@email.com', password: 'password');

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(index: 0)));
                },
                child: Text('Skip Login (Beta view)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
