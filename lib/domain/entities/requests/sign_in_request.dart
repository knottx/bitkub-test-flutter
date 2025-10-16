import 'package:equatable/equatable.dart';

class SignInRequest extends Equatable {
  final String phoneNumber;
  final String password;

  const SignInRequest({
    required this.phoneNumber,
    required this.password,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    phoneNumber,
    password,
  ];
}
