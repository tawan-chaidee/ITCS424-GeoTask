import 'package:flutter/material.dart';
import './login_page.dart';
import 'package:geotask/service/register_service.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class User {
  final String username;
  final String password;
  final String email;

  User({required this.username, required this.password, required this.email});
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _newUsernameController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60.0, top: 60),
              child: const Text(
                'GeoTask',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _newUsernameController,
              decoration: const InputDecoration(
                labelText: 'New Username',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  String newUsername = _newUsernameController.text;
                  String newPassword = _newPasswordController.text;
                  String email = _emailController.text;

                  // Call the registration service
                  try {
                    bool registrationResult =
                      await registerUser(newUsername, newPassword, email);

                    if (registrationResult) {
                      return showDialog(context: context, builder: (context) =>
                        AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Registration successful'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        )
                      );
                    }
                  } catch(e) {
                    if (e is RegisterException) {
                    return showDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.cause),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                    );
                    }
                  }
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  fixedSize:
                      Size(0.25 * MediaQuery.of(context).size.width, 50.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
