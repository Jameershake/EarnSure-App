import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _role = 'worker';
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Trim all values first
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();

    // Validation
    if (name.isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    // Register with Backend
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: _role,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Account Created Successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/home');
      }
    } else {
      if (mounted) {
        _showError(auth.error ?? 'Registration failed');
      }
    }
  }

  void _testMode() async {
    final testUser = {
      'id': 'test123',
      'name': _nameController.text.isEmpty ? 'Test User' : _nameController.text,
      'email': 'test@example.com',
      'role': _role,
      'phone': '1234567890',
    };

    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.prefs.setString('auth_token', 'test-token-123');
    await auth.prefs.setString('user_data', json.encode(testUser));
    await auth.checkAuth();

    if (mounted) {
      context.go('/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Test Mode Active'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Join EarnSure',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Create your account to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'your@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: '9876543210',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Min 6 characters',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Role Dropdown
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: InputDecoration(
                  labelText: 'I am a',
                  prefixIcon: const Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'worker',
                    child: Text('👷 Worker'),
                  ),
                  DropdownMenuItem(
                    value: 'employer',
                    child: Text('💼 Employer'),
                  ),
                ],
                onChanged: (value) => setState(() => _role = value!),
              ),
              const SizedBox(height: 24),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Test Mode Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _testMode,
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Test Mode (No Backend)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange[700],
                    side: BorderSide(color: Colors.orange[700]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Skip authentication for quick testing',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
              const SizedBox(height: 32),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
