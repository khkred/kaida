import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';

class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Profile Page'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () async{
              final authNotifer = ref.read(authNotifierProvider.notifier);

              await authNotifer.signOut();
            }, child: const Text('Sign Out')),
          ],
        ),
      ),
    );
  }
}
