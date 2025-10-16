import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/ui/extensions/build_context_extension.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/home/cubit/home_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/home/cubit/home_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:bitkub_test/ui/session/session_state.dart';
import 'package:bitkub_test/ui/utils/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomeScreenCubit(context.read(), sl());
      },
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late final HomeScreenCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeScreenCubit>();
  }

  void _listener(BuildContext context, HomeScreenState state) {
    switch (state.status) {
      case HomeScreenStatus.initial:
      case HomeScreenStatus.loading:
        break;

      case HomeScreenStatus.signOutSuccess:
        context.go(AppRoutes.signIn);

      case HomeScreenStatus.failure:
        AppDialog.error(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserInfo(),
              Center(
                child: _buildSignOutButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return BlocSelector<SessionCubit, SessionState, User?>(
      selector: (state) => state.user,
      builder: (context, user) {
        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello Welcome!',
              style: context.textTheme.headlineLarge,
            ),
            _buildUserInfoTile(
              title: 'First name',
              value: user?.firstName,
            ),
            _buildUserInfoTile(
              title: 'Last name',
              value: user?.lastName,
            ),
            _buildUserInfoTile(
              title: 'Phone number',
              value: user?.phoneNumber,
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfoTile({
    required String title,
    required String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textTheme.labelLarge,
        ),
        Text(
          value ?? '',
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return BlocSelector<HomeScreenCubit, HomeScreenState, bool>(
      selector: (state) => state.status.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return FilledButton.icon(
            onPressed: null,
            icon: const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(),
            ),
            label: const Text('Signing Out...'),
          );
        }

        return FilledButton.icon(
          onPressed: () {
            _cubit.signOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
        );
      },
    );
  }
}
