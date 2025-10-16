import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/home/cubit/home_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/home/cubit/home_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<Unit>>(Result.failure(const AppError('dummy')));
  });

  late MockSessionCubit sessionCubit;
  late MockSignOutUseCase signOutUseCase;

  setUp(() {
    sessionCubit = MockSessionCubit();
    signOutUseCase = MockSignOutUseCase();
  });

  group('HomeScreenCubit.signOut', () {
    blocTest<HomeScreenCubit, HomeScreenState>(
      'success: emits [loading, signOutSuccess] and sets user to null',
      build: () {
        when(
          signOutUseCase.call(),
        ).thenAnswer((_) async => Result.success(Unit()));

        when(sessionCubit.setUser(null)).thenReturn(null);
        return HomeScreenCubit(sessionCubit, signOutUseCase);
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const HomeScreenState().loading(),
        const HomeScreenState().signOutSuccess(),
      ],
      verify: (_) {
        verify(signOutUseCase.call()).called(1);
        verify(sessionCubit.setUser(null)).called(1);
        verifyNoMoreInteractions(sessionCubit);
      },
    );

    blocTest<HomeScreenCubit, HomeScreenState>(
      'failure: emits [loading, failure(e)] and does NOT clear session user',
      build: () {
        when(
          signOutUseCase.call(),
        ).thenAnswer(
          (_) async => Result.failure(const AppError('server down')),
        );
        return HomeScreenCubit(sessionCubit, signOutUseCase);
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const HomeScreenState().loading(),
        const HomeScreenState().failure(const AppError('server down')),
      ],
      verify: (_) {
        verify(signOutUseCase.call()).called(1);
        verifyNever(sessionCubit.setUser(any));
      },
    );
  });
}
