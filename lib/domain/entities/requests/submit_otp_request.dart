import 'package:equatable/equatable.dart';

class SubmitOtpRequest extends Equatable {
  final String phoneNumber;
  final String otp;
  final String ref;

  const SubmitOtpRequest({
    required this.phoneNumber,
    required this.otp,
    required this.ref,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    phoneNumber,
    otp,
    ref,
  ];
}
