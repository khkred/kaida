import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';

class PasswordResetPage extends HookConsumerWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (errorMessage.value != null)
                Text(
                  errorMessage.value!,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      try {
                        final authNotifier =
                            ref.read(authNotifierProvider.notifier);

                        await authNotifier.resetPassword(emailController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password reset email sent')));
                      } catch (e) {
                        errorMessage.value = e.toString();
                      }
                    }
                  },
                  child: const Text('Reset Password'))
            ],
          ),
        ),
      ),
    );
  }
}
