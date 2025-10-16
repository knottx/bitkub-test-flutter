import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/cubit/complete_sign_up_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/cubit/complete_sign_up_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<User>>(Result.failure(const AppError('dummy')));
  });

  late MockSessionCubit sessionCubit;
  late MockCompleteSignUpUseCase useCase;

  setUp(() {
    sessionCubit = MockSessionCubit();
    useCase = MockCompleteSignUpUseCase();
  });

  group('CompleteSignUpScreenCubit', () {
    blocTest<CompleteSignUpScreenCubit, CompleteSignUpScreenState>(
      'savePassword emits state with updated password',
      build: () => CompleteSignUpScreenCubit(
        sessionCubit,
        useCase,
        signUpToken: 'tok_abc',
        phoneNumber: '+66999999999',
      ),
      act: (cubit) => cubit.savePassword('P@ssw0rd'),
      expect: () => [
        const CompleteSignUpScreenState(
          signUpToken: 'tok_abc',
          phoneNumber: '+66999999999',
          password: 'P@ssw0rd',
        ),
      ],
    );

    blocTest<CompleteSignUpScreenCubit, CompleteSignUpScreenState>(
      'saveConfirmPassword emits state with updated confirmPassword',
      build: () => CompleteSignUpScreenCubit(
        sessionCubit,
        useCase,
        signUpToken: 'tok_abc',
        phoneNumber: '+66999999999',
      ),
      act: (cubit) => cubit.saveConfirmPassword('P@ssw0rd'),
      expect: () => [
        const CompleteSignUpScreenState(
          signUpToken: 'tok_abc',
          phoneNumber: '+66999999999',
          confirmPassword: 'P@ssw0rd',
        ),
      ],
    );

    blocTest<CompleteSignUpScreenCubit, CompleteSignUpScreenState>(
      'submit success: emits [success] and calls session.setUser(user); request uses confirmPassword',
      build: () {
        const user = User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        );

        when(useCase.call(any)).thenAnswer((_) async => Result.success(user));

        when(sessionCubit.setUser(user)).thenReturn(null);

        final cubit = CompleteSignUpScreenCubit(
          sessionCubit,
          useCase,
          signUpToken: 'tok_abc',
          phoneNumber: '+66999999999',
        );

        cubit
          ..savePassword('ignored_here')
          ..saveConfirmPassword('RealP@ss123');
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        const CompleteSignUpScreenState(
          signUpToken: 'tok_abc',
          phoneNumber: '+66999999999',
          password: 'ignored_here',
          confirmPassword: 'RealP@ss123',
        ).success(),
      ],
      verify: (_) {
        verify(
          useCase.call(
            argThat(
              predicate<CompleteSignUpRequest>(
                (r) =>
                    r.signUpToken == 'tok_abc' &&
                    r.phoneNumber == '+66999999999' &&
                    r.password == 'RealP@ss123',
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

    blocTest<CompleteSignUpScreenCubit, CompleteSignUpScreenState>(
      'submit failure: emits [failure(e)] and does NOT call setUser',
      build: () {
        final err = const AppError('weak password');
        when(useCase.call(any)).thenAnswer((_) async => Result.failure(err));

        final cubit = CompleteSignUpScreenCubit(
          sessionCubit,
          useCase,
          signUpToken: 'tok_bad',
          phoneNumber: '+66888888888',
        );
        cubit.saveConfirmPassword('weak');
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        const CompleteSignUpScreenState(
          signUpToken: 'tok_bad',
          phoneNumber: '+66888888888',
          confirmPassword: 'weak',
        ).failure(const AppError('weak password')),
      ],
      verify: (_) {
        verify(
          useCase.call(
            argThat(
              predicate<CompleteSignUpRequest>(
                (r) =>
                    r.signUpToken == 'tok_bad' &&
                    r.phoneNumber == '+66888888888' &&
                    r.password == 'weak',
              ),
            ),
          ),
        ).called(1);
        verifyNever(sessionCubit.setUser(any));
      },
    );
  });
}
