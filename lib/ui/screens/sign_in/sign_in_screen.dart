import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/sign_in/cubit/sign_in_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/sign_in/cubit/sign_in_screen_state.dart';
import 'package:bitkub_test/ui/utils/app_dialog.dart';
import 'package:bitkub_test/ui/widgets/password_text_form_field.dart';
import 'package:bitkub_test/ui/widgets/phone_number_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SignInScreenCubit(context.read(), sl());
      },
      child: const SignInScreenView(),
    );
  }
}

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({super.key});

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  late final SignInScreenCubit _cubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SignInScreenCubit>();
  }

  void _listener(BuildContext context, SignInScreenState state) {
    switch (state.status) {
      case SignInScreenStatus.initial:
      case SignInScreenStatus.loading:
        break;

      case SignInScreenStatus.success:
        context.go(AppRoutes.home);

      case SignInScreenStatus.failure:
        AppDialog.error(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInScreenCubit, SignInScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPhoneNumberField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                _buildSignInButton(),
                const SizedBox(height: 24),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return PhoneNumberTextFormField(
      onSaved: (value) {
        _cubit.savePhoneNumber(value ?? '');
      },
    );
  }

  Widget _buildPasswordField() {
    return PasswordTextFormField(
      labelText: 'Password',
      onSaved: (value) {
        _cubit.savePassword(value ?? '');
      },
    );
  }

  Widget _buildSignInButton() {
    return BlocSelector<SignInScreenCubit, SignInScreenState, bool>(
      selector: (state) => state.status.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return FilledButton.icon(
            onPressed: null,
            icon: const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(),
            ),
            label: const Text('Signing In...'),
          );
        }

        return FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FocusScope.of(context).unfocus();
              _cubit.signIn();
            }
          },
          child: const Text('Sign In'),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        if (_cubit.state.status.isLoading) return;
        context.push(AppRoutes.signUp);
      },
      child: const Text('Sign Up'),
    );
  }
}
