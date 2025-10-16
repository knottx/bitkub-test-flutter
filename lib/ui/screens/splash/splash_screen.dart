import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/splash/cubit/splash_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/splash/cubit/splash_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SplashScreenCubit(context.read(), sl());
      },
      child: const SplashScreenView(),
    );
  }
}

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  late final SplashScreenCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SplashScreenCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getProfile();
    });
  }

  void _listener(BuildContext context, SplashScreenState state) {
    switch (state.status) {
      case SplashScreenStatus.initial:
      case SplashScreenStatus.loading:
        break;

      case SplashScreenStatus.success:
        final sessionCubit = context.read<SessionCubit>();
        if (sessionCubit.state.status.isAuthenticated) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.signIn);
        }

      case SplashScreenStatus.failure:
        context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenCubit, SplashScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}
