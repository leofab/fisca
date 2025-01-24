import 'package:flutter_test/flutter_test.dart';
import 'package:app/screens/onboarding/onboarding_view_model.dart';

void main() {
  group('OnboardViewModel', () {
    late OnboardingViewModel viewModel;

    setUp(() {
      viewModel = OnboardingViewModel();
    });

    test('Initial state is correct', () {
      expect(viewModel.currentPageIndex, 0);
    });

    test('goToNextPage increments index', () {
      viewModel.goToNextPage();
      expect(viewModel.currentPageIndex, 1);
    });
  });
}
