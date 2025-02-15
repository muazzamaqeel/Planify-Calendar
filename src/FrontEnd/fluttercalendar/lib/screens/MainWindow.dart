import 'package:flutter/material.dart';
import 'TempRegistration.dart'; // Import the Sign-Up Page

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUpMode = false;
  bool _obscurePassword = true;

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

  // Email Validation
  String? _validateEmail(String email) {
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      return "Enter a valid email address";
    }
    return null;
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
                // App Logo
                const FlutterLogo(size: 80),
                const SizedBox(height: 24),

                // Title
                Text(
                  _isSignUpMode ? 'Create an Account' : 'Planify',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  _isSignUpMode ? 'Sign up to get started!' : 'Sign in to continue',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                    errorText: _emailController.text.isNotEmpty
                        ? _validateEmail(_emailController.text)
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password Field with Toggle Visibility
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign In / Sign Up Button
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    iconColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey.shade900,
                  ),
                  onPressed: () {
                    // Handle authentication logic
                    if (_validateEmail(_emailController.text) != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a valid email")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isSignUpMode ? "Signing Up..." : "Signing In...")),
                      );
                    }
                  },
                  child: Text(_isSignUpMode ? 'SIGN UP' : 'SIGN IN'),
                ),
                const SizedBox(height: 16),

                // Switch between Sign In & Sign Up
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
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      child: Text(_isSignUpMode ? 'Sign In' : 'Sign Up'),
                    ),
                  ],
                ),

                // Separate Sign-Up Page Navigation
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
