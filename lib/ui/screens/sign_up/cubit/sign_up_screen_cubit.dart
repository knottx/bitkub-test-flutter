import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/ui/screens/sign_up/cubit/sign_up_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreenCubit extends Cubit<SignUpScreenState> {
  final AuthRepository _authRepository;

  SignUpScreenCubit(
    this._authRepository,
  ) : super(const SignUpScreenState());

  void savePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  Future<void> signUp() async {
    emit(state.loading());
    final result = await _authRepository.signUp(
      request: SignUpRequest(phoneNumber: state.phoneNumber),
    );

    result.when(
      onSuccess: (otpRef) {
        emit(state.success(otpRef));
      },
      onFailure: (error) {
        emit(state.failure(error));
      },
    );
  }
}
