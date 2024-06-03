import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/constants/routes.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';

class EmailVerificationPage extends HookConsumerWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A Verification email has been sent to your email address. Please verify your email to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  // await authNotifier.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification email sent')));
                },
                child: const Text('Resend email')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser?.reload();

                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null && user.emailVerified) {
                    context.go(Routes.profile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Email not verified yet')));
                  }
                },
                child: const Text('I have verified my email')),
          ],
        ),
      ),
    );
  }
}
