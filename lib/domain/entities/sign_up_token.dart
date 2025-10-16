import 'package:equatable/equatable.dart';

class SignUpToken extends Equatable {
  final String? token;

  const SignUpToken({
    this.token,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    token,
  ];
}
