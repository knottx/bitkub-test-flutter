import 'package:bitkub_test/core/crypto/device_crypto_service_impl.dart';
import 'package:bitkub_test/data/api_client/api_client_demo.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/auth_remote_data_source_impl.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/user_remote/user_remote_data_source_impl.dart';
import 'package:bitkub_test/data/repositories/auth_repository_impl.dart';
import 'package:bitkub_test/data/repositories/token_repository_impl.dart';
import 'package:bitkub_test/data/repositories/user_repository_impl.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/repositories/token_repository.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
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

  final crypto = DeviceCryptoServiceImpl();

  sl.registerSingleton<TokenRepository>(
    TokenRepositoryImpl(flutterSecureStorage, crypto),
  );

  final apiClient = ApiClientDemo(sl());

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
