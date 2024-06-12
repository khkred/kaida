import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';

class PhoneVerificationPage extends HookConsumerWidget {
  const PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final phoneController = useTextEditingController();
    final codeController = useTextEditingController();
    final verificationId = useState<String?>(null);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone Number';
                  }
                  if (!RegExp(r'^\+?\d{10,}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      final authNotifier =
                          ref.read(authNotifierProvider.notifier);

                      try {
                        await authNotifier
                            .verifyPhoneNumber(phoneController.text,
                                (PhoneAuthCredential credential) async {
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Phone Number verified')));
                          Navigator.pop(context);
                        }, (FirebaseAuthException e) {
                          errorMessage.value = e.message;
                        }, (String mVerificationId, int? resendToken) {
                          verificationId.value = mVerificationId;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Verification code sent')));
                        }, (String mVerificationId) {
                          verificationId.value = mVerificationId;
                        });
                      } catch (e) {
                        errorMessage.value = e.toString();
                      }
                    }
                  },
                  child: const Text('Send Verification Code')),
              const SizedBox(height: 20),
              TextFormField(
                controller: codeController,
                decoration:
                    const InputDecoration(labelText: 'Verification Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (verificationId.value != null &&
                        formKey.currentState?.validate() == true) {
                      final authNotifier =
                          ref.read(authNotifierProvider.notifier);
                      try {
                        await authNotifier.signInWithPhoneNumber(
                            verificationId.value!, codeController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Phone Number Verified')));
                        Navigator.pop(context);
                      } catch (e) {
                        errorMessage.value = e.toString();
                      }
                    }
                  },
                  child: const Text('Verify Code')),
              if (errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    errorMessage.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
