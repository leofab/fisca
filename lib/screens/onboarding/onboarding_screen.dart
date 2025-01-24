import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel(),
      child: Scaffold(
        body: Center(
          child: Consumer<OnboardingViewModel>(
              builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  viewModel.currentImagePath,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 18),
                Text(
                  viewModel.currentTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 18),
                if (viewModel.currentPageIndex < viewModel.totalPages - 1)
                  ElevatedButton(
                    onPressed: viewModel.goToNextPage,
                    child: const Text('Next'),
                  ),
                const SizedBox(height: 18),
                if (viewModel.currentPageIndex == viewModel.totalPages - 1)
                  ElevatedButton(
                    onPressed: () {
                      viewModel.goToLogin(context);
                    },
                    child: const Text('Start'),
                  )
              ],
            );
          }),
        ),
      ),
    );
  }
}
