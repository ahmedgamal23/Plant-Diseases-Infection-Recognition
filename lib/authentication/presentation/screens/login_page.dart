import 'package:flutter/material.dart';

import '../compononts/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPageBody(),
    );
  }
}
