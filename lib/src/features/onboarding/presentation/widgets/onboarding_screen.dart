import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool isLastScreen;
  final VoidCallback? onFinish;

  const OnboardingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.isLastScreen = false,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
        if (isLastScreen)
          ElevatedButton(
            onPressed: onFinish,
            child: const Text('Get Started'),
          ),
      ],
    );
  }
}
