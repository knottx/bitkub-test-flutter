import 'package:bitkub_test/core/dependencies_initializer.dart';
import 'package:bitkub_test/ui/extensions/build_context_extension.dart';
import 'package:bitkub_test/ui/routes/app_routes.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/arguments/complete_sign_up_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/otp_verification/arguments/otp_verification_screen_arguments.dart';
import 'package:bitkub_test/ui/screens/otp_verification/cubit/otp_verification_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/otp_verification/cubit/otp_verification_screen_state.dart';
import 'package:bitkub_test/ui/utils/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatelessWidget {
  final OtpVerificationScreenArguments arguments;

  const OtpVerificationScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OtpVerificationScreenCubit(
          sl(),
          phoneNumber: arguments.phoneNumber,
          otpRef: arguments.otpRef,
        );
      },
      child: const OtpVerificationScreenView(),
    );
  }
}

class OtpVerificationScreenView extends StatefulWidget {
  const OtpVerificationScreenView({super.key});

  @override
  State<OtpVerificationScreenView> createState() =>
      _OtpVerificationScreenViewState();
}

class _OtpVerificationScreenViewState extends State<OtpVerificationScreenView> {
  late final OtpVerificationScreenCubit _cubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<OtpVerificationScreenCubit>();
  }

  void _listener(BuildContext context, OtpVerificationScreenState state) {
    switch (state.status) {
      case OtpVerificationScreenStatus.initial:
      case OtpVerificationScreenStatus.loading:
        break;

      case OtpVerificationScreenStatus.success:
        context.push(
          AppRoutes.completeSignUp,
          extra: CompleteSignUpScreenArguments(
            signUpToken: state.signUpToken!,
            phoneNumber: state.phoneNumber,
          ),
        );

      case OtpVerificationScreenStatus.failure:
        AppDialog.error(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerificationScreenCubit, OtpVerificationScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildOtpRef(),
                const SizedBox(height: 8),
                _buildOtpField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpRef() {
    return BlocSelector<
      OtpVerificationScreenCubit,
      OtpVerificationScreenState,
      String
    >(
      selector: (state) => state.otpRef.ref ?? '',
      builder: (context, ref) {
        return Text(
          'Ref: $ref',
          style: context.textTheme.labelLarge,
        );
      },
    );
  }

  Widget _buildOtpField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'OTP',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: 6,
      validator: (value) {
        final otp = value ?? '';
        if (otp.isEmpty) {
          return 'Please enter the OTP';
        }
        if (otp.length < 6) {
          return 'OTP must be 6 digits';
        }
        return null;
      },
      onSaved: (value) {
        _cubit.saveOtp(value ?? '');
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocSelector<
      OtpVerificationScreenCubit,
      OtpVerificationScreenState,
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
              _cubit.submitOtp();
            }
          },
          child: const Text('Submit'),
        );
      },
    );
  }
}
