import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/user_image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  bool isLogin = true;
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Login' : 'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                color: Colors.white,
              ),
              child: Column(
                children: [
                  if (!isLogin)
                    UserImagePicker(
                      onImagePick: (file) {
                        _pickedImage = file;
                      },
                    ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                onPressed: () async {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    return;
                  }
                  if (isLogin) {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } else {
                    try {
                      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (_pickedImage != null) {
                        final ref = FirebaseStorage.instance.ref().child('user_image').child('${result.user!.uid}.jpg');
                        await ref.putFile(_pickedImage!);
                        final imgUrl = await ref.getDownloadURL();
                        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
                          'username':'to be done..',
                          'email': emailController.text,
                          'image_url': imgUrl,
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Create Account' : 'Login', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ));
  }
}
