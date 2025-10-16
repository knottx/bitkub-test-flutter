import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/use_cases/complete_sign_up_use_case.dart';
import 'package:bitkub_test/ui/screens/complete_sign_up/cubit/complete_sign_up_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteSignUpScreenCubit extends Cubit<CompleteSignUpScreenState> {
  final SessionCubit _sessionCubit;
  final CompleteSignUpUseCase _useCase;

  CompleteSignUpScreenCubit(
    this._sessionCubit,
    this._useCase, {
    required String signUpToken,
    required String phoneNumber,
  }) : super(
         CompleteSignUpScreenState(
           signUpToken: signUpToken,
           phoneNumber: phoneNumber,
         ),
       );

  void savePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void saveConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  Future<void> submit() async {
    final result = await _useCase.call(
      CompleteSignUpRequest(
        signUpToken: state.signUpToken,
        phoneNumber: state.phoneNumber,
        password: state.confirmPassword,
      ),
    );

    result.when(
      onSuccess: (user) {
        _sessionCubit.setUser(user);
        emit(state.success());
      },
      onFailure: (error) {
        emit(state.failure(error));
      },
    );
  }
}
