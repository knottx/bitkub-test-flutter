import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String? accessToken;

  const Auth({
    this.accessToken,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    accessToken,
  ];
}
