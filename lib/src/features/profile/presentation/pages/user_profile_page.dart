import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';
import 'package:kaida/src/shared/widgets/confirmation_dialog.dart';

import '../../../../constants/routes.dart';

class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState is! AuthStateAuthenticated) {
      // Redirect to Sign In if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(Routes.signIn);
      });
      return const SizedBox.shrink();
    }
    
    void _showDeleteAccountDialog() {
      showDialog(context: context, builder: (context) => ConfirmationDialog(title: 'Delete Account', content: 'Are you sure you want to delete your account? This action cannot be undone.', onConfirm: () async {
        final authNotifier = ref.read(authNotifierProvider.notifier);

        await authNotifier.deleteAccount();


      }));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          actions: [
            IconButton(
              onPressed: () {
                context.push(Routes.editProfile);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(onPressed: (){
              context.push(Routes.changePassword);
            }, icon: const Icon(Icons.lock)),
            IconButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signOut();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('UserId : ${authState.userId}'),
              const SizedBox(height: 20),

              ElevatedButton(onPressed: (){
                context.push(Routes.changePassword);
              }, child: const Text('Change Password'),),

              ElevatedButton(onPressed: (){
                context.go(Routes.phoneVerification);
              }, child: const Text(
                'Verify Phone Number'
              ),),
              ElevatedButton(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                  },
                  child: const Text('Sign Out')),

              ElevatedButton(onPressed: _showDeleteAccountDialog,

              style: ElevatedButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete Account'),)


            ],
          ),
        ));
  }
}
