import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';

import '../../../../constants/routes.dart';

class PhoneVerificationPage extends HookConsumerWidget {
  const PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneFormKey = useMemoized(() => GlobalKey<FormState>());
    final codeFormKey = useMemoized(() => GlobalKey<FormState>());
    final phoneController = useTextEditingController();
    final codeController = useTextEditingController();
    final verificationId = useState<String?>(null);
    final errorMessage = useState<String?>(null);

    final authNotifier = ref.read(authNotifierProvider.notifier);
    
    String formatPhoneNumber(String phoneNumber) {
      
      if(phoneNumber.startsWith('+1')){
        return phoneNumber;
      } else {
        return '+1$phoneNumber';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: phoneFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
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
                        if (phoneFormKey.currentState?.validate() == true) {
                          try {
                            await authNotifier
                                .verifyPhoneNumber(formatPhoneNumber(phoneController.text.trim()),
                                    (PhoneAuthCredential credential) async {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Phone number verified')));
                              context.go(Routes.profile);
                            }, (FirebaseAuthException e) {
                              errorMessage.value = e.toString();
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (verificationId.value != null)
              Form(
                key: codeFormKey,
                child: Column(
                  children: [
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
                          if (codeFormKey.currentState?.validate() == true) {
                            try {
                              await authNotifier.signInWithPhoneNumber(
                                  verificationId.value!, codeController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Phone Number Verified')));
                             context.go(Routes.profile);
                            } catch (e) {
                              errorMessage.value = e.toString();
                            }
                          }
                        },
                        child: const Text('Verify Code')),
                  ],
                ),
              ),
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
    );
  }
}
