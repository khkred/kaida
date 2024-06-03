import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';

import '../../../../constants/routes.dart';

class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authState = ref.watch(authNotifierProvider);

    if(authState is! AuthStateAuthenticated) {
      // Redirect to Sign In if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(Routes.signIn);
      });
      return const SizedBox.shrink();
    }
    return  Scaffold(
      appBar: AppBar(title: const Text('Profile Page'),),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UserId : ${authState.userId}'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () async{
              await ref.read(authNotifierProvider.notifier).signOut();
            }, child: const Text('Sign Out')),
          ],
        ),
      )
    );
  }
}
