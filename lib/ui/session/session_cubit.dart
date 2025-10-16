import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/ui/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState());

  void setUser(User? user) {
    if (user != null) {
      emit(state.authenticated(user));
    } else {
      emit(state.unauthenticated());
    }
  }
}
