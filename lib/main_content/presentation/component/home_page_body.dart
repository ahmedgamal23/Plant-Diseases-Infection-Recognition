import 'package:flutter/material.dart';
import 'package:plant_infection_recognition/main_content/presentation/plants/plant_diseases.dart';
import '../insects/insects_detection.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Home Page'),
      //),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.cover,
            opacity: 0.8,
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context: context,
                image: 'assets/images/plant_diseases.jpeg', // Ensure this image is in your assets folder
                onPressed: () {
                  // Navigate to plant diseases page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlantDiseases(),));
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Plants Diseases Detection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),
              _buildButton(
                context: context,
                image: 'assets/images/insects.png', // Ensure this image is in your assets folder
                onPressed: () {
                  // Navigate to insects page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InsectsDetection(),));
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Insects Detection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String image,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 4, color: Colors.white30)
        ),
      ),
    );
  }
}
