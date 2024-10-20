import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password == _confirmPassword) {
        await _authController.registerUser(
            _firstName, _lastName, _email, _password);
        // Navigate to home page after successful registration.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: Validators.validateName,
                onSaved: (value) => _firstName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: Validators.validateName,
                onSaved: (value) => _lastName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.validateEmail,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.validatePassword,
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (value) => _confirmPassword = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
