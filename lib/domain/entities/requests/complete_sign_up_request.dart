import 'package:equatable/equatable.dart';

class CompleteSignUpRequest extends Equatable {
  final String signUpToken;
  final String phoneNumber;
  final String password;

  const CompleteSignUpRequest({
    required this.signUpToken,
    required this.phoneNumber,
    required this.password,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    signUpToken,
    phoneNumber,
    password,
  ];
}
