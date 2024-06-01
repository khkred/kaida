import 'package:go_router/go_router.dart';
import 'package:kaida/src/features/auth/presentation/pages/signup_page.dart';
import 'package:kaida/src/features/onboarding/presentation/pages/onboarding_page.dart';

import '../constants/routes.dart';
import '../features/auth/presentation/pages/signin_page.dart';

final GoRouter router = GoRouter(initialLocation: Routes.signIn, routes: [
  GoRoute(
    path: Routes.signIn,
    builder: (context, state) => const SignInPage(),
  ),
  //SignUp Route
  GoRoute(
    path: Routes.signUp,
    builder: (context, state) => const SignUpPage(),
  ),

  //OnBoarding Route
  GoRoute(
    path: Routes.onboarding,
    builder: (context, state) => const OnboardingPage(),
  )
]);
