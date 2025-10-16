import 'package:bitkub_test/core/crypto/device_crypto_service.dart';
import 'package:bitkub_test/data/api_client/api_client.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/auth_remote_data_source.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/user_remote/user_remote_data_source.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/repositories/token_repository.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/use_cases/complete_sign_up_use_case.dart';
import 'package:bitkub_test/domain/use_cases/sign_in_use_case.dart';
import 'package:bitkub_test/domain/use_cases/sign_out_use_case.dart';
import 'package:bitkub_test/domain/use_cases/splash_use_case.dart';
import 'package:bitkub_test/ui/session/session_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ApiClient,
  AuthRemoteDataSource,
  AuthRepository,
  CompleteSignUpUseCase,
  DeviceCryptoService,
  FlutterSecureStorage,
  SessionCubit,
  SignInUseCase,
  SignOutUseCase,
  SplashUseCase,
  TokenRepository,
  UserRemoteDataSource,
  UserRepository,
])
void main() {}
