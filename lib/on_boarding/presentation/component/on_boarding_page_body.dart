import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:plant_infection_recognition/core/constant.dart';
import '../../../authentication/presentation/screens/authentication_page.dart';

class OnBoardingPageBody extends StatelessWidget {
  const OnBoardingPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.fill,
          )
      ),
      child: Onboarding(
        swipeableBody: swipeContent(context),
        startIndex: 0,
        onPageChanges: (netDragDistance, pagesLength, currentIndex, slideDirection) {
          print('Page changed to $currentIndex, Direction: $slideDirection');
        },
        buildHeader: (context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection) {
          return swipeHeader(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection);
        },
        buildFooter: (context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection) {
          return swipeFooter(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection);
        },
        animationInMilliseconds: 200,
      ),
    );
  }

  Widget swipeHeader(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection) {
    return Padding(
      padding: const EdgeInsets.only(top: 50,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pagesLength,
              (index) => GestureDetector(
            onTap: () => setIndex(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? ConstantColor.dotActiveColor : ConstantColor.dotUnActiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> swipeContent(BuildContext context) {
    return const [
      // first page
      Padding(
        padding: EdgeInsets.only(right: 30, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Welcome to Plant Diseases Detection!',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  color: ConstantColor.bgTextColor
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "Plant Diseases App helps you identify and manage plant diseases. Let’s get started!",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: ConstantColor.bgTextColor,
              ),
            ),
          ],
        ),
      ),
      // second page
      Padding(
        padding: EdgeInsets.only(right: 30, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'How Plant Diseases App Works',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  color: ConstantColor.bgTextColor
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "Plant Diseases App uses advanced image recognition to analyze leaf patterns and detect diseases."
                  " Just snap a photo, and we’ll do the rest!",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: ConstantColor.bgTextColor
              ),
            ),
          ],
        ),
      ),
      // third page
      Padding(
        padding: EdgeInsets.only(right: 30, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permissions',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  color: ConstantColor.bgTextColor
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "To provide accurate results, Plant Diseases App needs access to your camera and photo library. Grant permissions to continue.",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: ConstantColor.bgTextColor
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget swipeFooter(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentIndex > 0)
            TextButton(
              onPressed: () => setIndex(currentIndex - 1),
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(ConstantColor.bgTextColor),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              child: const Text('Back'),
            ),
          if (currentIndex < pagesLength - 1)
            TextButton(
              onPressed: () => setIndex(currentIndex + 1),
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(ConstantColor.bgTextColor),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              child: const Text('Next'),
            ),
          if (currentIndex == pagesLength - 1)
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthenticationPage()),
              ),
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(ConstantColor.bgTextColor),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              child: const Text('Get Started'),
            ),
        ],
      ),
    );
  }
}

