import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/presentation/pages/password_reset_page.dart';
import 'package:kaida/src/features/auth/presentation/pages/signup_page.dart';
import 'package:kaida/src/features/auth/provider/auth_providers.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';
import 'package:kaida/src/features/onboarding/presentation/pages/onboarding_page.dart';
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
        final isLoggingIn =
            state.uri.path == Routes.signIn || state.uri.path == Routes.signUp;

        // Onboarding check
        final isOnBoardingComplete =
            await SharedPreferencesUtil.isOnboardingComplete();

        //Logging for Debugging Purposes
        print('Current Auth State: $authState');
        print('Is Onboarding Complete: $isOnBoardingComplete');
        print('Current Location: ${state.uri.path}');

        // Basic Onboarding check
        if (!isOnBoardingComplete && state.uri.path != Routes.onboarding) {
          return Routes.onboarding;
        }

        // We are check if Onboarding completed and yet the user is not yet loggedIn
        if (isOnBoardingComplete && !isLoggedIn && !isLoggingIn && state.uri.path != Routes.signIn && state.uri.path != Routes.passwordReset) {
          return Routes.signIn;
        }

        // Here we are checking if the user is already authenticated but they are on one of the three pages on the right side, then we redirect them to profile
        if (isLoggedIn &&
            (state.uri.path == Routes.signIn ||
                state.uri.path == Routes.signUp ||
                state.uri.path == Routes.onboarding)) {
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
      ]);
}
