import 'package:bitkub_test/domain/use_cases/sign_out_use_case.dart';
import 'package:bitkub_test/ui/screens/home/cubit/home_screen_state.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SessionCubit _sessionCubit;
  final SignOutUseCase _useCase;

  HomeScreenCubit(
    this._sessionCubit,
    this._useCase,
  ) : super(const HomeScreenState());

  Future<void> signOut() async {
    emit(state.loading());
    final result = await _useCase.call();

    result.when(
      onSuccess: (_) {
        _sessionCubit.setUser(null);
        emit(state.signOutSuccess());
      },
      onFailure: (error) {
        emit(state.failure(error));
      },
    );
  }
}
