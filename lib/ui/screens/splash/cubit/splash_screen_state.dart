import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:equatable/equatable.dart';

enum SplashScreenStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == SplashScreenStatus.loading;
}

class SplashScreenState extends Equatable {
  final SplashScreenStatus status;
  final AppError? error;

  const SplashScreenState({
    this.status = SplashScreenStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    error,
  ];

  SplashScreenState copyWith({
    SplashScreenStatus? status,
    AppError? error,
  }) {
    return SplashScreenState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  SplashScreenState loading() {
    return copyWith(
      status: SplashScreenStatus.loading,
    );
  }

  SplashScreenState success() {
    return copyWith(
      status: SplashScreenStatus.success,
    );
  }

  SplashScreenState failure(
    AppError error,
  ) {
    return copyWith(
      status: SplashScreenStatus.failure,
      error: error,
    );
  }
}
