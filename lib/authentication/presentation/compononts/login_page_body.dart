import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../main_content/presentation/screens/home_page.dart';
import '../../../core/constant.dart';
import '../screens/authentication_page.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  _LoginPageBodyState createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if(_emailController.text.trim() == "admin" && _passwordController.text.trim() == "admin")
    {
      // TODO: for test
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Login successful',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      ).show();
    }
    else if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Sign in user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Success',
          desc: 'Login successful',
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ).show();
      } catch (e) {
        print("********** ERROR **********");
        print(e.toString());
        print("***************************");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: 'Login failed: ${e}',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'Please enter your email to reset password',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      // Check if email exists
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: 'No account found for that email',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Password reset email sent',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationPage(),));
        },
      ).show();
    } catch (e) {
      print("********** ERROR **********");
      print(e.toString());
      print("***************************");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'Failed to send password reset email: ${e}',
        btnOkOnPress: () {},
      ).show();
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
                  const SizedBox(height: 20),
                  generateTextFormField("Email", false, _emailController),
                  const SizedBox(height: 30),
                  generateTextFormField("Password", true, _passwordController),
                  TextButton(
                    onPressed: _resetPassword,
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ConstantColor.tabBarLabelColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: _login,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Login",
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
        return null;
      },
    );
  }
}
