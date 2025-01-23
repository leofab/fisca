import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250),
          child: CarouselView(
            itemExtent: 350,
            itemSnapping: true,
            scrollDirection: Axis.horizontal,
            children: [
              Hero(tag: '1', child: Image.asset('assets/1.png')),
              Hero(tag: '2', child: Image.asset('assets/2.png')),
              Hero(tag: '3', child: Image.asset('assets/3.png')),
            ],
          ),
        ),
      ),
    );
  }
}
