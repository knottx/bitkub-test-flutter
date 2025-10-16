import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/arguments/complete_sign_up_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/cubit/complete_sign_up_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/cubit/complete_sign_up_screen_state.dart';
import 'package:bitkub_test/ui/utils/app_dialog.dart';
import 'package:bitkub_test/ui/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CompleteSignUpScreen extends StatelessWidget {
  final CompleteSignUpScreenArguments arguments;

  const CompleteSignUpScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CompleteSignUpScreenCubit(
          context.read(),
          sl(),
          signUpToken: arguments.signUpToken,
          phoneNumber: arguments.phoneNumber,
        );
      },
      child: const CompleteSignUpScreenView(),
    );
  }
}

class CompleteSignUpScreenView extends StatefulWidget {
  const CompleteSignUpScreenView({super.key});

  @override
  State<CompleteSignUpScreenView> createState() =>
      _CompleteSignUpScreenViewState();
}

class _CompleteSignUpScreenViewState extends State<CompleteSignUpScreenView> {
  late final CompleteSignUpScreenCubit _cubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CompleteSignUpScreenCubit>();
  }

  void _listener(BuildContext context, CompleteSignUpScreenState state) {
    switch (state.status) {
      case CompleteSignUpScreenStatus.initial:
      case CompleteSignUpScreenStatus.loading:
        break;

      case CompleteSignUpScreenStatus.success:
        context.go(AppRoutes.home);

      case CompleteSignUpScreenStatus.failure:
        AppDialog.error(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompleteSignUpScreenCubit, CompleteSignUpScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Sign Up'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildConfirmPasswordField() {
    return PasswordTextFormField(
      labelText: 'Confirm Password',
      onSaved: (value) {
        _cubit.saveConfirmPassword(value ?? '');
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocSelector<
      CompleteSignUpScreenCubit,
      CompleteSignUpScreenState,
      bool
    >(
      selector: (state) => state.status.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return FilledButton.icon(
            onPressed: null,
            icon: const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(),
            ),
            label: const Text('Submitting...'),
          );
        }

        return FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FocusScope.of(context).unfocus();
              _cubit.submit();
            }
          },
          child: const Text('Submit'),
        );
      },
    );
  }
}
