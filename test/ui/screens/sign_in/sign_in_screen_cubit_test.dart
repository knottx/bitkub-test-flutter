import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/sign_in/cubit/sign_in_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/sign_in/cubit/sign_in_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<User>>(Result.failure(const AppError('dummy')));
  });

  late MockSessionCubit sessionCubit;
  late MockSignInUseCase signInUseCase;

  setUp(() {
    sessionCubit = MockSessionCubit();
    signInUseCase = MockSignInUseCase();
  });

  group('SignInScreenCubit', () {
    blocTest<SignInScreenCubit, SignInScreenState>(
      'savePhoneNumber emits state with updated phoneNumber',
      build: () => SignInScreenCubit(sessionCubit, signInUseCase),
      act: (cubit) => cubit.savePhoneNumber('+66999999999'),
      expect: () => [
        const SignInScreenState(phoneNumber: '+66999999999'),
      ],
    );

    blocTest<SignInScreenCubit, SignInScreenState>(
      'savePassword emits state with updated password',
      build: () => SignInScreenCubit(sessionCubit, signInUseCase),
      act: (cubit) => cubit.savePassword('P@ssw0rd'),
      expect: () => [
        const SignInScreenState(password: 'P@ssw0rd'),
      ],
    );

    blocTest<SignInScreenCubit, SignInScreenState>(
      'signIn success: emits [loading, success] and calls session.setUser(user) with correct request',
      build: () {
        const user = User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        );

        when(
          signInUseCase.call(any),
        ).thenAnswer((_) async => Result.success(user));

        when(sessionCubit.setUser(user)).thenReturn(null);

        final cubit = SignInScreenCubit(sessionCubit, signInUseCase);
        cubit
          ..savePhoneNumber('+66999999999')
          ..savePassword('P@ssw0rd');
        return cubit;
      },
      act: (cubit) => cubit.signIn(),
      expect: () => [
        const SignInScreenState(
          phoneNumber: '+66999999999',
          password: 'P@ssw0rd',
        ).loading(),
        const SignInScreenState(
          phoneNumber: '+66999999999',
          password: 'P@ssw0rd',
        ).success(),
      ],
      verify: (_) {
        verify(
          signInUseCase.call(
            argThat(
              predicate<SignInRequest>(
                (r) =>
                    r.phoneNumber == '+66999999999' && r.password == 'P@ssw0rd',
              ),
            ),
          ),
        ).called(1);

        verify(
          sessionCubit.setUser(
            const User(
              id: 'u1',
              firstName: 'Knot',
              lastName: 'Tippun',
              phoneNumber: '+66999999999',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(sessionCubit);
      },
    );

    blocTest<SignInScreenCubit, SignInScreenState>(
      'signIn failure: emits [loading, failure(e)] and does NOT call setUser',
      build: () {
        when(
          signInUseCase.call(any),
        ).thenAnswer((_) async => Result.failure(const AppError('invalid')));
        final cubit = SignInScreenCubit(sessionCubit, signInUseCase);
        cubit
          ..savePhoneNumber('+66888888888')
          ..savePassword('wrong');
        return cubit;
      },
      act: (cubit) => cubit.signIn(),
      expect: () => [
        const SignInScreenState(
          phoneNumber: '+66888888888',
          password: 'wrong',
        ).loading(),
        const SignInScreenState(
          phoneNumber: '+66888888888',
          password: 'wrong',
        ).failure(const AppError('invalid')),
      ],
      verify: (_) {
        verify(
          signInUseCase.call(
            argThat(
              predicate<SignInRequest>(
                (r) => r.phoneNumber == '+66888888888' && r.password == 'wrong',
              ),
            ),
          ),
        ).called(1);
        verifyNever(sessionCubit.setUser(any));
      },
    );
  });
}
