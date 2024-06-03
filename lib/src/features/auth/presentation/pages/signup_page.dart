import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/routes.dart';
import '../../provider/auth_providers.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              //Email TextFormField
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  // Email Format Validator using Regex
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }

                  // Phone Number Validator using Regex
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }

                  return null;
                },
              ),

              //Password TextFormField
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  // This will cover all the scenarios
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),
              //Show the error here
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
                        await authNotifier.signUp(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                            phoneController.text);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Form validated successfully')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          errorMessage.value = e.toString();
                        }
                      }
                    }
                  },
                  child: const Text('Sign Up')),

              TextButton(
                  onPressed: () {
                    context.go(Routes.signIn);
                  },
                  child: const Text('Already have an account? Sign In'))
            ],
          ),
        ),
      ),
    );
  }
}
