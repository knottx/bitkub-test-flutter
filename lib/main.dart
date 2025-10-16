import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/routes/app_router.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDependencies();

  runApp(
    BlocProvider(
      create: (_) => SessionCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
