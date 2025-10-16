import 'package:bitkub_test/data/data_sources/auth_remote/auth_remote_data_source.dart';
import 'package:bitkub_test/data/mappers/auth_mapper.dart';
import 'package:bitkub_test/data/mappers/otp_ref_mapper.dart';
import 'package:bitkub_test/data/mappers/requests/complete_sign_up_request_mapper.dart';
import 'package:bitkub_test/data/mappers/requests/sign_in_request_mapper.dart';
import 'package:bitkub_test/data/mappers/requests/sign_up_request_mapper.dart';
import 'package:bitkub_test/data/mappers/requests/submit_otp_request_mapper.dart';
import 'package:bitkub_test/data/mappers/sign_up_token_mapper.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';
import 'package:bitkub_test/domain/entities/sign_up_token.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  const AuthRepositoryImpl(
    this._remote,
  );

  @override
  Future<Result<Auth>> signIn({
    required SignInRequest request,
  }) async {
    try {
      final dto = await _remote.signIn(
        request: SignInRequestMapper.toDto(request),
      );
      return Result.success(AuthMapper.toEntity(dto));
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }

  @override
  Future<Result<Unit>> signOut() async {
    try {
      await _remote.signOut();
      return Result.success(Unit());
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }

  @override
  Future<Result<OtpRef>> signUp({
    required SignUpRequest request,
  }) async {
    try {
      final dto = await _remote.signUp(
        request: SignUpRequestMapper.toDto(request),
      );
      return Result.success(OtpRefMapper.toEntity(dto));
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }

  @override
  Future<Result<SignUpToken>> submitOtp({
    required SubmitOtpRequest request,
  }) async {
    try {
      final dto = await _remote.submitOtp(
        request: SubmitOtpRequestMapper.toDto(request),
      );
      return Result.success(SignUpTokenMapper.toEntity(dto));
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }

  @override
  Future<Result<Auth>> completeSignUp({
    required CompleteSignUpRequest request,
  }) async {
    try {
      final dto = await _remote.completeSignUp(
        request: CompleteSignUpRequestMapper.toDto(request),
      );
      return Result.success(AuthMapper.toEntity(dto));
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }
}
