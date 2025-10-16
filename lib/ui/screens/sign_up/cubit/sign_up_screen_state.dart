import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:equatable/equatable.dart';

enum SignUpScreenStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == SignUpScreenStatus.loading;
}

class SignUpScreenState extends Equatable {
  final SignUpScreenStatus status;
  final String phoneNumber;
  final OtpRef? otpRef;
  final AppError? error;

  const SignUpScreenState({
    this.status = SignUpScreenStatus.initial,
    this.phoneNumber = '',
    this.otpRef,
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    phoneNumber,
    otpRef,
    error,
  ];

  SignUpScreenState copyWith({
    SignUpScreenStatus? status,
    String? phoneNumber,
    OtpRef? otpRef,
    AppError? error,
  }) {
    return SignUpScreenState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpRef: otpRef ?? this.otpRef,
      error: error ?? this.error,
    );
  }

  SignUpScreenState loading() {
    return copyWith(
      status: SignUpScreenStatus.loading,
    );
  }

  SignUpScreenState success(OtpRef otpRef) {
    return copyWith(
      status: SignUpScreenStatus.success,
      otpRef: otpRef,
    );
  }

  SignUpScreenState failure(
    AppError error,
  ) {
    return copyWith(
      status: SignUpScreenStatus.failure,
      error: error,
    );
  }
}
