import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/splash/cubit/splash_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/splash/cubit/splash_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<User?>>(Result.failure(const AppError('dummy')));
  });

  late MockSessionCubit sessionCubit;
  late MockSplashUseCase splashUseCase;

  setUp(() {
    sessionCubit = MockSessionCubit();
    splashUseCase = MockSplashUseCase();
  });

  group('SplashScreenCubit.getProfile', () {
    blocTest<SplashScreenCubit, SplashScreenState>(
      'emits success and calls setUser(user) when use case returns Success(User)',
      build: () {
        const user = User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        );
        when(
          splashUseCase.call(),
        ).thenAnswer((_) async => Result.success(user));

        when(sessionCubit.setUser(user)).thenReturn(null);
        return SplashScreenCubit(sessionCubit, splashUseCase);
      },
      act: (cubit) => cubit.getProfile(),
      expect: () => [
        const SplashScreenState().success(),
      ],
      verify: (_) {
        verify(splashUseCase.call()).called(1);
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

    blocTest<SplashScreenCubit, SplashScreenState>(
      'emits success and calls setUser(null) when use case returns Success(null)',
      build: () {
        when(
          splashUseCase.call(),
        ).thenAnswer((_) async => Result.success(null));
        when(sessionCubit.setUser(null)).thenReturn(null);
        return SplashScreenCubit(sessionCubit, splashUseCase);
      },
      act: (cubit) => cubit.getProfile(),
      expect: () => [
        const SplashScreenState().success(),
      ],
      verify: (_) {
        verify(splashUseCase.call()).called(1);
        verify(sessionCubit.setUser(null)).called(1);
        verifyNoMoreInteractions(sessionCubit);
      },
    );

    blocTest<SplashScreenCubit, SplashScreenState>(
      'emits failure(error) and does NOT call setUser when use case returns Failure',
      build: () {
        when(
          splashUseCase.call(),
        ).thenAnswer(
          (_) async => Result.failure(const AppError('unauthorized')),
        );
        return SplashScreenCubit(sessionCubit, splashUseCase);
      },
      act: (cubit) => cubit.getProfile(),
      expect: () => [
        const SplashScreenState().failure(const AppError('unauthorized')),
      ],
      verify: (_) {
        verify(splashUseCase.call()).called(1);
        verifyNever(sessionCubit.setUser(any));
      },
    );
  });
}
