import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final Auth? auth;
  final User? user;

  const Session({
    this.auth,
    this.user,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    auth,
    user,
  ];

  bool get isAuthenticated {
    final accessToken = auth?.accessToken;
    return accessToken != null && accessToken.isNotEmpty;
  }
}
