import 'package:bitkub_test/domain/entities/otp_ref.dart';

class OtpVerificationScreenArguments {
  final String phoneNumber;
  final OtpRef otpRef;

  const OtpVerificationScreenArguments({
    required this.phoneNumber,
    required this.otpRef,
  });
}
