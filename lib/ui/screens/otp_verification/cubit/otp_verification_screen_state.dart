import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:equatable/equatable.dart';

enum OtpVerificationScreenStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == OtpVerificationScreenStatus.loading;
}

class OtpVerificationScreenState extends Equatable {
  final OtpVerificationScreenStatus status;
  final String phoneNumber;
  final OtpRef otpRef;
  final String otp;
  final String? signUpToken;
  final AppError? error;

  const OtpVerificationScreenState({
    this.status = OtpVerificationScreenStatus.initial,
    required this.phoneNumber,
    required this.otpRef,
    this.otp = '',
    this.signUpToken,
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    phoneNumber,
    otpRef,
    otp,
    signUpToken,
    error,
  ];

  OtpVerificationScreenState copyWith({
    OtpVerificationScreenStatus? status,
    String? phoneNumber,
    OtpRef? otpRef,
    String? otp,
    String? signUpToken,
    AppError? error,
  }) {
    return OtpVerificationScreenState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpRef: otpRef ?? this.otpRef,
      otp: otp ?? this.otp,
      signUpToken: signUpToken ?? this.signUpToken,
      error: error ?? this.error,
    );
  }

  OtpVerificationScreenState loading() {
    return copyWith(
      status: OtpVerificationScreenStatus.loading,
    );
  }

  OtpVerificationScreenState success(String signUpToken) {
    return copyWith(
      status: OtpVerificationScreenStatus.success,
      signUpToken: signUpToken,
    );
  }

  OtpVerificationScreenState failure(
    AppError error,
  ) {
    return copyWith(
      status: OtpVerificationScreenStatus.failure,
      error: error,
    );
  }
}
