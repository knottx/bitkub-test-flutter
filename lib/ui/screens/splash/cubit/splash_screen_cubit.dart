import 'package:bitkub_test/domain/use_cases/splash_use_case.dart';
import 'package:bitkub_test/ui/screens/splash/cubit/splash_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final SessionCubit _sessionCubit;
  final SplashUseCase _userCase;

  SplashScreenCubit(
    this._sessionCubit,
    this._userCase,
  ) : super(const SplashScreenState());

  Future<void> getProfile() async {
    final result = await _userCase.call();
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
