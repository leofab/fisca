import 'package:flutter/material.dart';

class OnboardingViewModel with ChangeNotifier {
  int _currentPageIndex = 0;

  final List<String> _imagePaths = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
  ];

  final List<String> _titles = [
    'Monitor your spending easily',
    'Plan your finances effectively',
    'Scan receipts instantly',
  ];

  int get currentPageIndex => _currentPageIndex;
  String get currentImagePath => _imagePaths[_currentPageIndex];
  String get currentTitle => _titles[_currentPageIndex];
  int get totalPages => _imagePaths.length;

  void goToNextPage() {
    if (_currentPageIndex < _imagePaths.length - 1) {
      _currentPageIndex++;
      notifyListeners();
    }
  }

  void goToLogin() {
    if (_currentPageIndex == _imagePaths.length - 1) {}
  }
}
