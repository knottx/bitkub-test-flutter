import 'package:bitkub_test/data/api_client/api_client_demo.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/auth_remote_data_source_impl.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/user_remote/user_remote_data_source_impl.dart';
import 'package:bitkub_test/data/repositories/auth_repository_impl.dart';
import 'package:bitkub_test/data/repositories/user_repository_impl.dart';
import 'package:bitkub_test/data/store/session_store_impl.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:bitkub_test/domain/use_cases/complete_sign_up_use_case.dart';
import 'package:bitkub_test/domain/use_cases/sign_in_use_case.dart';
import 'package:bitkub_test/domain/use_cases/sign_out_use_case.dart';
import 'package:bitkub_test/domain/use_cases/splash_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initializeDependencies() {
  final flutterSecureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final sessionStore = SessionStoreImpl(flutterSecureStorage);
  sl.registerSingleton<SessionStore>(sessionStore);

  final apiClient = ApiClientDemo(sessionStore);

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(AuthRemoteDataSourceImpl(apiClient)),
  );

  sl.registerSingleton<UserRepository>(
    UserRepositoryImpl(UserRemoteDataSourceImpl(apiClient)),
  );

  sl.registerFactory<SplashUseCase>(
    () => SplashUseCase(sl(), sl()),
  );

  sl.registerFactory<SignInUseCase>(
    () => SignInUseCase(sl(), sl(), sl()),
  );

  sl.registerFactory<SignOutUseCase>(
    () => SignOutUseCase(sl(), sl()),
  );

  sl.registerFactory<CompleteSignUpUseCase>(
    () => CompleteSignUpUseCase(sl(), sl(), sl()),
  );
}
