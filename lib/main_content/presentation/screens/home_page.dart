import 'package:flutter/material.dart';
import '../component/home_page_body.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePageBody(),
    );
  }
}

