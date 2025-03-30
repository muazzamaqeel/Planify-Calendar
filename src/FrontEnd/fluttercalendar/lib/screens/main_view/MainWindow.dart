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

  final String _baseUrl = "http://localhost:8000/api";
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

  // ✅ Fixed `_authenticateUser()`
  Future<void> _authenticateUser() async {
    const endpoint = 'signup/';

    setState(() {
      _statusMessage = '';
      _statusColor = Colors.transparent;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Call Made")));

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_or_username': _usernameController.text,
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
    } // ✅ Missing bracket added here
  }

  // ✅ Fixed `_validateUser()`
  Future<void> _validateUser() async {
    const endpoint = 'validate_user/';

    setState(() {
      _statusMessage = '';
      _statusColor = Colors.transparent;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Call Made")));

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_or_username': _usernameController.text, // ✅ Fixed field name
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _statusMessage = data['message'] == 'Login successful'
              ? "User Successfully Verified"
              : data['message'] ?? 'Unknown response';
          _statusColor =
              data['message'] == 'Login successful' ? Colors.green : Colors.red;
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

  // ✅ Unchanged `_connectWithBackend()`
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
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email or Username',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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
                if (_statusMessage.isNotEmpty)
                  Text(
                    _statusMessage,
                    style: TextStyle(color: _statusColor),
                  ),
                FilledButton(
                  onPressed: _validateUser,
                  child: const Text("SIGN IN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
