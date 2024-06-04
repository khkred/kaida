import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';

import '../../../auth/domain/models/app_user.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final errorMessage = useState<String?>(null);

    final authState = ref.watch(authNotifierProvider);

    if (authState is! AuthStateAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: const Center(
          child: Text('Please sign in to edit your profile'),
        ),
      );
    }

    final userId = authState.userId;

    useEffect(() {
      Future<void> loadUserData() async {
        final userDoc = await FirebaseFirestore.instance.collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final user = AppUser.fromFireStore(userDoc.data()!);
          nameController.text = user.name;
          emailController.text = user.email;
          phoneController.text = user.phoneNumber;
        }
      }
      loadUserData();
      return;
    }, []);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'),),
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

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (errorMessage.value != null)
                Text(errorMessage.value!,
                  style: const TextStyle(color: Colors.red),),
              ElevatedButton(onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  try {
                    final userRef = FirebaseFirestore.instance.collection(
                        'users').doc(userId);

                    await userRef.update({
                      'name': nameController.text,
                      'email': emailController.text,
                      'phoneNumber': phoneController.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Profile updated successfully')));
                  }
                  catch (e) {
                    errorMessage.value = e.toString();
                  }
                }
              }, child: const Text('Save Changes')),


            ],
          ),
        ),
      ),
    );
  }
}
