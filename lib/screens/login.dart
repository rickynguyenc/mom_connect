import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 36,
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.blue,
          ),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          width: 200,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              final value = FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
              value.then((value) {
                Navigator.pushNamed(context, '/chat');
              });
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    ));
  }
}
