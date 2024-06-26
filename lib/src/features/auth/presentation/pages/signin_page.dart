import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../constants/routes.dart';
import '../../provider/auth_providers.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
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

              const SizedBox(
                height: 20,
              ),
              //Show the error here
              if (errorMessage.value != null)
                Text(
                  errorMessage.value!,
                  style: const TextStyle(color: Colors.red),
                ),

              //Sign In Button
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      try {
                        final authNotifier =
                            ref.read(authNotifierProvider.notifier);
                        await authNotifier.signIn(
                            emailController.text, passwordController.text);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Signed In Successfully')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          if (e is FirebaseAuthException &&
                              e.code == 'email-not-verified') {
                            context.go(Routes.emailVerification);
                          } else {
                            errorMessage.value = e.toString();
                          }
                        }
                      }
                    }
                  },
                  child: const Text('Sign In'),),

              ElevatedButton.icon(onPressed: () async {
                try {
                  final authNotifier = ref.read(authNotifierProvider.notifier);
                  await authNotifier.signInWithGoogle();

                  if(context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed in with Google successfully')));
                  }
                }
                catch (e) {
                  if(context.mounted) {
                    errorMessage.value = e.toString();
                  }
                }
              }, label: const Text('Sign in with Google'),
              icon: const Icon(Icons.login),),

              //Go to SignUp
              TextButton(
                  onPressed: () {
                    context.go(Routes.signUp);
                  },
                  child: const Text('Don\'t have an account? Sign Up')),

              TextButton(
                onPressed: () {
                  context.push(Routes.passwordReset);
                },
                child: const Text('Forgot Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
