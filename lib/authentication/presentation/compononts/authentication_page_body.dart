import 'package:flutter/material.dart';
import 'package:plant_infection_recognition/authentication/presentation/screens/login_page.dart';
import '../../../core/constant.dart';
import '../screens/register_page.dart';

class AuthenticationPageBody extends StatefulWidget {
  const AuthenticationPageBody({super.key});

  @override
  State<AuthenticationPageBody> createState() => _AuthenticationPageBodyState();
}

class _AuthenticationPageBodyState extends State<AuthenticationPageBody> with SingleTickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          children: [
            // Image section
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              padding: const EdgeInsets.only(right: 20, bottom: 50, left: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'), // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: ConstantColor.bgTextColor
                    ),
                  ),
                  Text(
                    "Plant Diseases App helps you identify and manage plant diseases. Let’s get started!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: ConstantColor.bgTextColor
                    ),
                  ),
                ],
              ),
            ),
            // TabBar section
            Container(
              color: ConstantColor.tabBarIndicatorColor,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Login'),
                  Tab(text: 'Register'),
                ],
                labelColor: ConstantColor.tabBarLabelColor,
                indicatorColor: ConstantColor.tabBarIndicatorColor,
              ),
            ),
            // TabBarView section
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  LoginPage(),
                  RegisterPage(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}