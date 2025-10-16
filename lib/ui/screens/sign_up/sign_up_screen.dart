import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/otp_verification/arguments/otp_verification_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/sign_up/cubit/sign_up_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/sign_up/cubit/sign_up_screen_state.dart';
import 'package:bitkub_test/ui/utils/app_dialog.dart';
import 'package:bitkub_test/ui/widgets/phone_number_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SignUpScreenCubit(sl());
      },
      child: const SignUpScreenView(),
    );
  }
}

class SignUpScreenView extends StatefulWidget {
  const SignUpScreenView({super.key});

  @override
  State<SignUpScreenView> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  late final SignUpScreenCubit _cubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SignUpScreenCubit>();
  }

  void _listener(BuildContext context, SignUpScreenState state) {
    switch (state.status) {
      case SignUpScreenStatus.initial:
      case SignUpScreenStatus.loading:
        break;

      case SignUpScreenStatus.success:
        context.push(
          AppRoutes.otpVerification,
          extra: OtpVerificationScreenArguments(
            phoneNumber: state.phoneNumber,
            otpRef: state.otpRef!,
          ),
        );

      case SignUpScreenStatus.failure:
        AppDialog.error(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpScreenCubit, SignUpScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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

  Widget _buildSignUpButton() {
    return BlocSelector<SignUpScreenCubit, SignUpScreenState, bool>(
      selector: (state) => state.status.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return FilledButton.icon(
            onPressed: null,
            icon: const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(),
            ),
            label: const Text('Signing Up...'),
          );
        }

        return FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FocusScope.of(context).unfocus();
              _cubit.signUp();
            }
          },
          child: const Text('Sign Up'),
        );
      },
    );
  }
}
