import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    _buildCarouselItem('assets/1.png', 'Monitor your spending easily'),
    _buildCarouselItem('assets/2.png', 'Plan your finances effectively'),
    _buildCarouselItem('assets/3.png', 'Scan receipts instantly'),
  ];

  void _goToNextPage() {
    setState(() {
      if (_currentPageIndex < _pages.length - 1) {
        _currentPageIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pages[_currentPageIndex],
            const SizedBox(height: 20),
            if (_currentPageIndex < _pages.length - 1)
              ElevatedButton(
                onPressed: _goToNextPage,
                child: const Text('Next'),
              ),
            if (_currentPageIndex == _pages.length - 1)
              ElevatedButton(
                onPressed: () {},
                child: const Text('Start'),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCarouselItem(String imagePath, String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.9,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}
