import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';
import 'package:bitkub_test/domain/entities/sign_up_token.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:bitkub_test/ui/screens/otp_verification/cubit/otp_verification_screen_cubit.dart';
import 'package:bitkub_test/ui/screens/otp_verification/cubit/otp_verification_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<SignUpToken>>(Result.failure(const AppError('dummy')));
  });

  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('OtpVerificationScreenCubit', () {
    blocTest<OtpVerificationScreenCubit, OtpVerificationScreenState>(
      'saveOtp emits state with updated otp',
      build: () => OtpVerificationScreenCubit(
        authRepository,
        phoneNumber: '+66999999999',
        otpRef: const OtpRef(ref: 'otp_ref_001'),
      ),
      act: (cubit) => cubit.saveOtp('123456'),
      expect: () => [
        const OtpVerificationScreenState(
          phoneNumber: '+66999999999',
          otpRef: OtpRef(ref: 'otp_ref_001'),
          otp: '123456',
        ),
      ],
    );

    blocTest<OtpVerificationScreenCubit, OtpVerificationScreenState>(
      'submitOtp success: emits [loading, success(token)] and calls repo with correct request',
      build: () {
        when(authRepository.submitOtp(request: anyNamed('request'))).thenAnswer(
          (_) async =>
              Result.success(const SignUpToken(token: 'signup_token_abc')),
        );

        final cubit = OtpVerificationScreenCubit(
          authRepository,
          phoneNumber: '+66999999999',
          otpRef: const OtpRef(ref: 'otp_ref_001'),
        );
        cubit.saveOtp('123456');
        return cubit;
      },
      act: (cubit) => cubit.submitOtp(),
      expect: () => [
        const OtpVerificationScreenState(
          phoneNumber: '+66999999999',
          otpRef: OtpRef(ref: 'otp_ref_001'),
          otp: '123456',
        ).loading(),
        const OtpVerificationScreenState(
          phoneNumber: '+66999999999',
          otpRef: OtpRef(ref: 'otp_ref_001'),
          otp: '123456',
        ).success('signup_token_abc'),
      ],
      verify: (_) {
        verify(
          authRepository.submitOtp(
            request: argThat(
              predicate<SubmitOtpRequest>(
                (r) =>
                    r.phoneNumber == '+66999999999' &&
                    r.otp == '123456' &&
                    r.ref == 'otp_ref_001',
              ),
              named: 'request',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<OtpVerificationScreenCubit, OtpVerificationScreenState>(
      'submitOtp failure: emits [loading, failure(e)]',
      build: () {
        when(
          authRepository.submitOtp(request: anyNamed('request')),
        ).thenAnswer(
          (_) async => Result.failure(const AppError('invalid otp')),
        );

        final cubit = OtpVerificationScreenCubit(
          authRepository,
          phoneNumber: '+66888888888',
          otpRef: const OtpRef(ref: 'otp_ref_bad'),
        );
        cubit.saveOtp('000000');
        return cubit;
      },
      act: (cubit) => cubit.submitOtp(),
      expect: () => [
        const OtpVerificationScreenState(
          phoneNumber: '+66888888888',
          otpRef: OtpRef(ref: 'otp_ref_bad'),
          otp: '000000',
        ).loading(),
        const OtpVerificationScreenState(
          phoneNumber: '+66888888888',
          otpRef: OtpRef(ref: 'otp_ref_bad'),
          otp: '000000',
        ).failure(const AppError('invalid otp')),
      ],
    );
  });
}
