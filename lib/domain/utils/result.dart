import 'package:bitkub_test/domain/utils/app_error.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Success] with a value of type [T]
/// or a [Failure] with an [Exception].
///
/// Use [Result.success] to create a successful result with a value of type [T].
/// Use [Result.failure] to create a failure result with an [Exception].
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Success():
///     print(result.value);
///   case Failure():
///     print(result.error);
/// }
/// ```
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  /// Creates an instance of Result containing a value
  factory Result.success(T value) => Success._(value);

  /// Create an instance of Result containing an error
  factory Result.failure(AppError error) => Failure._(error);

  void when({
    required void Function(T value) onSuccess,
    required void Function(AppError error) onFailure,
  }) {
    final result = this;
    switch (result) {
      case Success<T>():
        onSuccess(result.value);
      case Failure<T>():
        onFailure(result.error);
    }
  }
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  /// Returned value in result
  final T value;

  const Success._(this.value);

  @override
  String toString() => 'Result<$T>.success($value)';
}

/// Subclass of Result for errors
final class Failure<T> extends Result<T> {
  /// Returned error in result
  final AppError error;

  const Failure._(this.error);

  @override
  String toString() => 'Result<$T>.failure($error)';
}

/// Used instead of `void` as a return statement for a function
/// when no value is to be returned.
///
/// There is only one value of type [Unit].
final class Unit {
  static const Unit _instance = Unit._();
  const Unit._();
  factory Unit() => _instance;

  @override
  String toString() => '()';

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => 0;
}
