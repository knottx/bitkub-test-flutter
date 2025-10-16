import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:bitkub_test/ui/session/session_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionCubit', () {
    test('initial state is unauthenticated (default SessionState)', () {
      final cubit = SessionCubit();
      expect(cubit.state, const SessionState());
      cubit.close();
    });

    blocTest<SessionCubit, SessionState>(
      'emits authenticated(user) when setUser(user) is called',
      build: () => SessionCubit(),
      act: (cubit) => cubit.setUser(
        const User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        ),
      ),
      expect: () => [
        const SessionState().authenticated(
          const User(
            id: 'u1',
            firstName: 'Knot',
            lastName: 'Tippun',
            phoneNumber: '+66999999999',
          ),
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits unauthenticated() when setUser(null) is called',
      build: () => SessionCubit(),
      act: (cubit) => cubit.setUser(null),
      expect: () => [
        const SessionState().unauthenticated(),
      ],
    );
  });
}
