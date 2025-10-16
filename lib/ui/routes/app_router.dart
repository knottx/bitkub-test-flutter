import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/arguments/complete_sign_up_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/complete_sign_up_screen.dart';
import 'package:bitkub_test/ui/screens/home/home_screen.dart';
import 'package:bitkub_test/ui/screens/otp_verification/arguments/otp_verification_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/otp_verification/otp_verification_screen.dart';
import 'package:bitkub_test/ui/screens/sign_in/sign_in_screen.dart';
import 'package:bitkub_test/ui/screens/sign_up/sign_up_screen.dart';
import 'package:bitkub_test/ui/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final arguments = state.extra as OtpVerificationScreenArguments;
          return OtpVerificationScreen(arguments: arguments);
        },
      ),
      GoRoute(
        path: AppRoutes.completeSignUp,
        builder: (context, state) {
          final arguments = state.extra as CompleteSignUpScreenArguments;
          return CompleteSignUpScreen(arguments: arguments);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
