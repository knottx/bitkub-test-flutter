import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/sign_up/cubit/sign_up_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/sign_up/cubit/sign_up_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<OtpRef>>(Result.failure(const AppError('dummy')));
  });

  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('SignUpScreenCubit', () {
    blocTest<SignUpScreenCubit, SignUpScreenState>(
      'savePhoneNumber emits state with updated phoneNumber',
      build: () => SignUpScreenCubit(authRepository),
      act: (cubit) => cubit.savePhoneNumber('+66999999999'),
      expect: () => [
        const SignUpScreenState(phoneNumber: '+66999999999'),
      ],
    );

    blocTest<SignUpScreenCubit, SignUpScreenState>(
      'signUp success: emits [loading, success(otpRef)] and calls repo with correct request',
      build: () {
        when(authRepository.signUp(request: anyNamed('request'))).thenAnswer(
          (_) async => Result.success(const OtpRef(ref: 'otp_ref_001')),
        );
        final cubit = SignUpScreenCubit(authRepository);
        cubit.savePhoneNumber(
          '+66999999999',
        );
        return cubit;
      },
      act: (cubit) => cubit.signUp(),
      expect: () => [
        const SignUpScreenState(phoneNumber: '+66999999999').loading(),
        const SignUpScreenState(
          phoneNumber: '+66999999999',
        ).success(const OtpRef(ref: 'otp_ref_001')),
      ],
      verify: (_) {
        verify(
          authRepository.signUp(
            request: argThat(
              predicate<SignUpRequest>(
                (r) => r.phoneNumber == '+66999999999',
              ),
              named: 'request',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<SignUpScreenCubit, SignUpScreenState>(
      'signUp failure: emits [loading, failure(e)]',
      build: () {
        when(authRepository.signUp(request: anyNamed('request'))).thenAnswer(
          (_) async => Result.failure(const AppError('phone already used')),
        );
        final cubit = SignUpScreenCubit(authRepository);
        cubit.savePhoneNumber('+66888888888');
        return cubit;
      },
      act: (cubit) => cubit.signUp(),
      expect: () => [
        const SignUpScreenState(phoneNumber: '+66888888888').loading(),

        const SignUpScreenState(
          phoneNumber: '+66888888888',
        ).failure(const AppError('phone already used')),
      ],
      verify: (_) {
        verify(
          authRepository.signUp(
            request: argThat(
              predicate<SignUpRequest>(
                (r) => r.phoneNumber == '+66888888888',
              ),
              named: 'request',
            ),
          ),
        ).called(1);
      },
    );
  });
}
