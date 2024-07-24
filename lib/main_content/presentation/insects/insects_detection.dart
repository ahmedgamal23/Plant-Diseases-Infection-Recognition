import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_infection_recognition/core/constant.dart';
import 'package:plant_infection_recognition/main_content/presentation/insects/real_time_insects_detection.dart';

import 'image_insects_detection.dart';

class InsectsDetection extends StatefulWidget {
  const InsectsDetection({super.key});

  @override
  State<InsectsDetection> createState() => _InsectsDetectionState();
}

class _InsectsDetectionState extends State<InsectsDetection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _showAppBar = _tabController.index != 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: ConstantColor.mainContentBgColor,
      appBar: _showAppBar
          ? AppBar(
        title: const Text("Insects Detection"),
        backgroundColor: ConstantColor.mainContentBgColor,
        actions: const [
          Padding(
            // Icon image for person's login
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/user.png'), // Replace with your image path
            ),
          ),
        ],
      )
          : null,
      body: Column(
        children: [
          // List of all scanned images or videos
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                imageDetection(),
                detectImages(),
                user != null ? showProfile(user) : const Center(child: CircularProgressIndicator()),
                //showProfile(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigator(),
    );
  }

  Widget imageDetection() {
    return const ImageInsectsDetection();
  }

  Widget detectImages() {
    return const RealTimeInsectsDetection();
  }

  Widget showProfile(User user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user.png'), // Replace with your image URL
          ),
          const SizedBox(height: 20),
          Text(
            user.displayName ?? '',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            user.email ?? 'ahmed@gmail.com',
            style: TextStyle(fontSize: 20, color: Colors.grey[800], fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 20),
          const Text(
            'About Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return Material(
      elevation: 8.0,
      color: ConstantColor.bottomNavigatorColor,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.home), text: 'Image Detection'),
          Tab(icon: Icon(Icons.scanner), text: 'Real Time'),
          Tab(icon: Icon(Icons.person), text: 'Profile'),
        ],
        indicatorColor: ConstantColor.bottomNavigatorSelectedIconColor,
        labelColor: ConstantColor.bottomNavigatorSelectedIconColor,
        unselectedLabelColor: ConstantColor.bottomNavigatorUnSelectedIconColor,
      ),
    );
  }
}
