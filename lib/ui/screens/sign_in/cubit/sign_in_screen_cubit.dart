import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/use_cases/sign_in_use_case.dart';
import 'package:bitkub_test/ui/screens/sign_in/cubit/sign_in_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreenCubit extends Cubit<SignInScreenState> {
  final SessionCubit _sessionCubit;
  final SignInUseCase _useCase;

  SignInScreenCubit(
    this._sessionCubit,
    this._useCase,
  ) : super(const SignInScreenState());

  void savePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void savePassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> signIn() async {
    emit(state.loading());
    final result = await _useCase.call(
      SignInRequest(
        phoneNumber: state.phoneNumber,
        password: state.password,
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
