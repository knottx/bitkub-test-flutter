import 'package:equatable/equatable.dart';

class AppError extends Equatable implements Exception {
  final String message;

  const AppError(this.message);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    message,
  ];

  factory AppError.fromError(Object error) {
    if (error is AppError) {
      return error;
    }

    return AppError(error.toString());
  }
}
