import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaida/src/features/onboarding/presentation/widgets/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onBoardingComplete', true);

    context.go(Routes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(
        children: [
          const OnboardingScreen(title: 'Welcome to Our App', description: 'This is the first onBoarding Screen', image: 'assets/images/onboarding1.jpeg'),
          const OnboardingScreen(title: 'Explore Features', description: 'This is the second onBoarding Screen', image: 'assets/images/onboarding2.jpeg'),
          OnboardingScreen(title: 'Get Started', description: 'This is the third onBoarding Screen', image: 'assets/images/onboarding3.jpeg', isLastScreen: true, onFinish: () =>  completeOnboarding(context),),
        ],
      )
    );
  }
}


