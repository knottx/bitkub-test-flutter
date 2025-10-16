import 'package:equatable/equatable.dart';

class SignUpRequest extends Equatable {
  final String phoneNumber;

  const SignUpRequest({
    required this.phoneNumber,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    phoneNumber,
  ];
}
