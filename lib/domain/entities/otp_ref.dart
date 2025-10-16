import 'package:equatable/equatable.dart';

class OtpRef extends Equatable {
  final String? ref;

  const OtpRef({
    this.ref,
  });

  @override
  List<Object?> get props => [
    ref,
  ];
}
