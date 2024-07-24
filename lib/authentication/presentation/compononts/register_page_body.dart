import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:plant_infection_recognition/authentication/presentation/compononts/login_page_body.dart';

import '../../../core/constant.dart';
import '../screens/authentication_page.dart';
import '../screens/login_page.dart';

class RegisterPageBody extends StatefulWidget {
  const RegisterPageBody({super.key});

  @override
  _RegisterPageBodyState createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<RegisterPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Check if email already exists
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
        if (userDoc.exists) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: 'Email already exists',
            btnOkOnPress: () {},
          ).show();
          return;
        }

        // Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user details to Firestore
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'name': name,
          'email': email,
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Success',
          desc: 'Registration successful',
          btnOkOnPress: () {
            // Navigate to the HomePage or any other page
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationPage(),));
          },
        ).show();
      } catch (e) {
        print("********** ERROR **********");
        print(e);
        print("*********************");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: 'Registration failed: $e',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  generateTextFormField("Name", false, _nameController),
                  const SizedBox(height: 5),
                  generateTextFormField("Email", false, _emailController),
                  const SizedBox(height: 5),
                  generateTextFormField("Password", true, _passwordController),
                  const SizedBox(height: 5),
                  generateTextFormField("Confirm Password", true, _confirmPasswordController),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _register,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateTextFormField(String hintText, bool isPassword, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38),
        enabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        fillColor: Colors.white70,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      ),
      style: const TextStyle(
        fontSize: 20,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        if (hintText == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (hintText == "Password" && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (hintText == "Confirm Password" && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
