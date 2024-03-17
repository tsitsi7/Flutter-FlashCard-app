import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupUsernameController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _loginUsernameController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to FlashCard-quiz App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sign-up Fields
                  TextField(
                    controller: _signupEmailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _signupUsernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _signupPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 20.0),
                  // Login Fields
                  ElevatedButton(
                    onPressed: () {
                      showLoginDialog(); // Show login dialog when "Login" is pressed
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String email = _signupEmailController.text.trim();
    String username = _signupUsernameController.text.trim();
    String password = _signupPasswordController.text.trim();

    // Basic validation
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    // Save user details locally using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('username', username);
    prefs.setString('password', password);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign-up successful!'),
      ),
    );
  }

  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _loginUsernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _loginPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                login();
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void login() async {
    String username = _loginUsernameController.text.trim();
    String password = _loginPasswordController.text;

    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username and password'),
        ),
      );
      return;
    }
    // Fetch stored username and password for authentication
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? '';
    String storedPassword = prefs.getString('password') ?? '';
    // Authenticate user
    if (username == storedUsername && password == storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home_screen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
        ),
      );
    }
    // Implement your login logic here
    // For now, let's assume a successful login
    // Here you can check against stored credentials or make API requests

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
      ),
    );
  }
}
