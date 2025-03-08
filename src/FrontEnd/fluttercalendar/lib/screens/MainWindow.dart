import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'TempRegistration.dart'; // Import the Sign-Up Page

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUpMode = false;
  bool _obscurePassword = true;

  // For Flutter Web, typically:
  final String _baseUrl = "http://localhost:8000/api";

  // We store status text and color here
  String _statusMessage = '';
  Color _statusColor = Colors.transparent;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TempRegistration()),
    );
  }

  String? _validateEmail(String email) {
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      return "Enter a valid email address";
    }
    return null;
  }

  // Sign Up (POST to /signup/)
  Future<void> _authenticateUser() async {
    const endpoint = 'signup/';

    // Clear old status
    setState(() {
      _statusMessage = '';
      _statusColor = Colors.transparent;
    });

    // Show "Call Made" immediately
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Call Made")));

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _statusMessage = data['message'] ?? 'Sign Up Successful';
          _statusColor = Colors.green;
        });
      } else {
        setState(() {
          _statusMessage = "Error: ${response.statusCode} - ${response.body}";
          _statusColor = Colors.red;
        });
      }
    } catch (error) {
      setState(() {
        _statusMessage = "Network Error: $error";
        _statusColor = Colors.red;
      });
    }
  }

  // Sign In / Validate (POST to /validate_user/)
  Future<void> _validateUser() async {
    const endpoint = 'validate_user/';

    // Clear old status
    setState(() {
      _statusMessage = '';
      _statusColor = Colors.transparent;
    });

    // Show "Call Made"
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Call Made")));

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Login successful') {
          setState(() {
            _statusMessage = "User Successfully Verified";
            _statusColor = Colors.green;
          });
        } else {
          setState(() {
            _statusMessage = data['message'] ?? 'Unknown response';
            _statusColor = Colors.red;
          });
        }
      } else {
        setState(() {
          _statusMessage = "Error: ${response.statusCode} - ${response.body}";
          _statusColor = Colors.red;
        });
      }
    } catch (error) {
      setState(() {
        _statusMessage = "Network Error: $error";
        _statusColor = Colors.red;
      });
    }
  }

  // Connect with Backend (GET /)
  Future<void> _connectWithBackend() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'No message received')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response.statusCode} - ${response.body}"),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlutterLogo(size: 80),
                const SizedBox(height: 24),
                Text(
                  _isSignUpMode ? 'Create an Account' : 'Planify',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Username / Email Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                    errorText: _usernameController.text.isNotEmpty
                        ? _validateEmail(_usernameController.text)
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Status message (e.g. "User Successfully Verified")
                if (_statusMessage.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Sign Up or Sign In Button
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blueGrey.shade900,
                  ),
                  onPressed: () {
                    if (_isSignUpMode) {
                      _authenticateUser(); // POST /signup/
                    } else {
                      _validateUser(); // POST /validate_user/
                    }
                  },
                  child: Text(_isSignUpMode ? 'SIGN UP' : 'SIGN IN'),
                ),
                const SizedBox(height: 16),
                // Connect with Backend
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.green.shade700,
                  ),
                  onPressed: _connectWithBackend,
                  child: const Text("Connect with Backend"),
                ),
                const SizedBox(height: 16),
                // Switch Between Sign Up and Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isSignUpMode
                        ? 'Already have an account?'
                        : 'Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUpMode = !_isSignUpMode;
                          _usernameController.clear();
                          _passwordController.clear();
                          _statusMessage = '';
                          _statusColor = Colors.transparent;
                        });
                      },
                      child: Text(_isSignUpMode ? 'Sign In' : 'Sign Up'),
                    ),
                  ],
                ),
                // Optional: separate sign-up page
                if (!_isSignUpMode)
                  TextButton(
                    onPressed: _navigateToSignUp,
                    child: const Text("Create an account"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
