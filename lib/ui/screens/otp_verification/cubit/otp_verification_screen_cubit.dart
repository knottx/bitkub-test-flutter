import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/ui/screens/otp_verification/cubit/otp_verification_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpVerificationScreenCubit extends Cubit<OtpVerificationScreenState> {
  final AuthRepository _authRepository;

  OtpVerificationScreenCubit(
    this._authRepository, {
    required String phoneNumber,
    required OtpRef otpRef,
  }) : super(
         OtpVerificationScreenState(
           phoneNumber: phoneNumber,
           otpRef: otpRef,
         ),
       );

  void saveOtp(String otp) {
    emit(state.copyWith(otp: otp));
  }

  Future<void> submitOtp() async {
    emit(state.loading());
    final result = await _authRepository.submitOtp(
      request: SubmitOtpRequest(
        phoneNumber: state.phoneNumber,
        otp: state.otp,
        ref: state.otpRef.ref ?? '',
      ),
    );

    result.when(
      onSuccess: (signUpToken) {
        emit(state.success(signUpToken.token ?? ''));
      },
      onFailure: (error) {
        emit(state.failure(error));
      },
    );
  }
}
