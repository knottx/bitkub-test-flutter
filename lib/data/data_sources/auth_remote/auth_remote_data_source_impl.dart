import 'package:bitkub_test/data/api_client/api_client.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/auth_remote_data_source.dart';
import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/data/dtos/otp_ref.dart';
import 'package:bitkub_test/data/dtos/requests/complete_sign_up_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/sign_in_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/sign_up_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/submit_otp_request_dto.dart';
import 'package:bitkub_test/data/dtos/sign_up_token_dto.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(
    this._apiClient,
  );

  @override
  Future<AuthDto> signIn({
    required SignInRequestDto request,
  }) async {
    final response = await _apiClient.post(
      '/auth/signin',
      data: request.toJson(),
    );
    return AuthDto.fromJson(response);
  }

  @override
  Future<void> signOut() async {
    await _apiClient.post('/auth/signout');
  }

  @override
  Future<OtpRefDto> signUp({
    required SignUpRequestDto request,
  }) async {
    final response = await _apiClient.post(
      '/auth/signup',
      data: request.toJson(),
    );
    return OtpRefDto.fromJson(response);
  }

  @override
  Future<SignUpTokenDto> submitOtp({
    required SubmitOtpRequestDto request,
  }) async {
    final response = await _apiClient.post(
      '/auth/submit-otp',
      data: request.toJson(),
    );
    return SignUpTokenDto.fromJson(response);
  }

  @override
  Future<AuthDto> completeSignUp({
    required CompleteSignUpRequestDto request,
  }) async {
    final response = await _apiClient.post(
      '/auth/complete-signup',
      data: request.toJson(),
    );
    return AuthDto.fromJson(response);
  }
}
