import 'package:flutter/material.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUpMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A “modern” look often has a clean layout with ample whitespace
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App logo or decorative header can go here
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

                Text(
                  _isSignUpMode
                      ? 'Sign up to get started!'
                      : 'Sign in to continue',
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
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
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
                      child: Text(
                        _isSignUpMode ? 'Sign In' : 'Sign Up',
                      ),
                    ),
                  ],
                ),
              
              // Add a privacy policy link
              TextButton(
                onPressed: () {
                  // Handle privacy policy navigation
                },
                child: Text('Privacy Policy'),
              ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
