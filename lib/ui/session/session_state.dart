import 'package:bitkub_test/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

enum SessionStatus {
  initial,
  unauthenticated,
  authenticated;

  bool get isAuthenticated => this == SessionStatus.authenticated;
}

class SessionState extends Equatable {
  final SessionStatus status;
  final User? user;

  const SessionState({
    this.status = SessionStatus.initial,
    this.user,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    status,
    user,
  ];

  SessionState copyWith({
    SessionStatus? status,
    User? user,
  }) {
    return SessionState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  SessionState authenticated(User user) {
    return copyWith(
      status: SessionStatus.authenticated,
      user: user,
    );
  }

  SessionState unauthenticated() {
    return const SessionState(
      status: SessionStatus.unauthenticated,
    );
  }
}
