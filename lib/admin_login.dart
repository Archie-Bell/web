import 'package:flutter/material.dart';
import 'package:web/admin_panel.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement authentication logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in as $_email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);  // This will pop the current screen off the navigation stack
              },
            ),
            // Resulting in text overflow
            // const Text(
            //   'Go back to SCWW',
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400), // Set max width for the form
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevents taking the full screen width
                children: [
                  // Admin Panel Text above the form
                  const Text(
                    'Admin Panel',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Address label and TextField
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email Address:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter an email' : null,
                          onSaved: (value) => _email = value,
                        ),
                        const SizedBox(height: 20),
                        
                        // Password label and TextField
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your password',
                          ),
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a password' : null,
                          onSaved: (value) => _password = value,
                        ),
                        const SizedBox(height: 10),
                        
                        // Row for "Forgot your password?" and "Login" button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons to the left and right
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password functionality
                              },
                              child: const Text('Forgot your password?'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement login logic
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
