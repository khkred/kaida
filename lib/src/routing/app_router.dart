import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/presentation/pages/email_verification_page.dart';
import 'package:kaida/src/features/auth/presentation/pages/password_reset_page.dart';
import 'package:kaida/src/features/auth/presentation/pages/phone_verification_page.dart';
import 'package:kaida/src/features/auth/presentation/pages/signup_page.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';
import 'package:kaida/src/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:kaida/src/features/profile/presentation/pages/change_password_page.dart';
import 'package:kaida/src/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:kaida/src/features/profile/presentation/pages/user_profile_page.dart';
import 'package:kaida/src/utils/shared_preferences_util.dart';

import '../constants/routes.dart';
import '../features/auth/presentation/pages/signin_page.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
      initialLocation: Routes.signIn,
      redirect: (context, state) async {
        //Returns AuthState
        final authState = ref.watch(authNotifierProvider);
        final isLoggedIn = authState is AuthStateAuthenticated;
        final isLoggingIn = state.uri.path == Routes.signIn ||
            state.uri.path == Routes.signUp ||
            state.uri.path == Routes.passwordReset;

        //For email verification
        final user = FirebaseAuth.instance.currentUser;
        final isEmailVerified = user?.emailVerified ?? false;

        // Onboarding check
        final isOnBoardingComplete =
            await SharedPreferencesUtil.isOnboardingComplete();

        //Logging for Debugging Purposes
        print('Current Auth State: $authState');
        print('Is Onboarding Complete: $isOnBoardingComplete');
        print('Current Location: ${state.uri.path}');
        print('Email Verified: $isEmailVerified');

        // Basic Onboarding check
        if (!isOnBoardingComplete && state.uri.path != Routes.onboarding) {
          return Routes.onboarding;
        }

        // Check if Onboarding completed and the user is not yet logged in
        if (isOnBoardingComplete && !isLoggedIn && !isLoggingIn) {
          return Routes.signIn;
        }

        // Redirect to email verification if the user is logged in but the email is not verified
        if (isLoggedIn & !isEmailVerified &&
            state.uri.path != Routes.emailVerification) {
          return Routes.emailVerification;
        }

        // Check if the user is already authenticated but they are on one of the specified pages, then redirect them to profile
        if (isLoggedIn &&
            isEmailVerified &&
            (state.uri.path == Routes.signIn ||
                state.uri.path == Routes.signUp ||
                state.uri.path == Routes.onboarding ||
                state.uri.path == Routes.passwordReset)) {
          return Routes.profile;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.signIn,
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: Routes.signUp,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const UserProfilePage(),
        ),
        GoRoute(
          path: Routes.passwordReset,
          builder: (context, state) => const PasswordResetPage(),
        ),
        GoRoute(
          path: Routes.emailVerification,
          builder: (context, state) => const EmailVerificationPage(),
        ),
        GoRoute(
          path: Routes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: Routes.changePassword,
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: Routes.phoneVerification,
          builder: (context, state) => const PhoneVerificationPage(),
        ),
      ]);
}
