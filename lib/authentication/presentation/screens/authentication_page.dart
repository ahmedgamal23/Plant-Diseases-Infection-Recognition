import 'package:flutter/material.dart';
import '../compononts/authentication_page_body.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthenticationPageBody(),
    );
  }
}


