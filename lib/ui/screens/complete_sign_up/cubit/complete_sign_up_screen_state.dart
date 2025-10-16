import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:equatable/equatable.dart';

enum CompleteSignUpScreenStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == CompleteSignUpScreenStatus.loading;
}

class CompleteSignUpScreenState extends Equatable {
  final CompleteSignUpScreenStatus status;
  final String signUpToken;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final AppError? error;

  const CompleteSignUpScreenState({
    this.status = CompleteSignUpScreenStatus.initial,
    required this.signUpToken,
    required this.phoneNumber,
    this.password = '',
    this.confirmPassword = '',
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    signUpToken,
    phoneNumber,
    password,
    confirmPassword,
    error,
  ];

  CompleteSignUpScreenState copyWith({
    CompleteSignUpScreenStatus? status,
    String? signUpToken,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    AppError? error,
  }) {
    return CompleteSignUpScreenState(
      status: status ?? this.status,
      signUpToken: signUpToken ?? this.signUpToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      error: error ?? this.error,
    );
  }

  CompleteSignUpScreenState loading() {
    return copyWith(
      status: CompleteSignUpScreenStatus.loading,
    );
  }

  CompleteSignUpScreenState success() {
    return copyWith(
      status: CompleteSignUpScreenStatus.success,
    );
  }

  CompleteSignUpScreenState failure(
    AppError error,
  ) {
    return copyWith(
      status: CompleteSignUpScreenStatus.failure,
      error: error,
    );
  }
}
