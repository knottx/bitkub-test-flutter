import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:equatable/equatable.dart';

enum SignInScreenStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == SignInScreenStatus.loading;
}

class SignInScreenState extends Equatable {
  final SignInScreenStatus status;
  final String phoneNumber;
  final String password;
  final AppError? error;

  const SignInScreenState({
    this.status = SignInScreenStatus.initial,
    this.phoneNumber = '',
    this.password = '',
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    phoneNumber,
    password,
    error,
  ];

  SignInScreenState copyWith({
    SignInScreenStatus? status,
    String? phoneNumber,
    String? password,
    AppError? error,
  }) {
    return SignInScreenState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      error: error ?? this.error,
    );
  }

  SignInScreenState loading() {
    return copyWith(
      status: SignInScreenStatus.loading,
    );
  }

  SignInScreenState success() {
    return copyWith(
      status: SignInScreenStatus.success,
    );
  }

  SignInScreenState failure(
    AppError error,
  ) {
    return copyWith(
      status: SignInScreenStatus.failure,
      error: error,
    );
  }
}
