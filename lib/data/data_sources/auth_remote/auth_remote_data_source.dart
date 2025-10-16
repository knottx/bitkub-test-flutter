import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/data/dtos/otp_ref.dart';
import 'package:bitkub_test/data/dtos/requests/complete_sign_up_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/sign_in_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/sign_up_request_dto.dart';
import 'package:bitkub_test/data/dtos/requests/submit_otp_request_dto.dart';
import 'package:bitkub_test/data/dtos/sign_up_token_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthDto> signIn({
    required SignInRequestDto request,
  });

  Future<void> signOut();

  Future<OtpRefDto> signUp({
    required SignUpRequestDto request,
  });

  Future<SignUpTokenDto> submitOtp({
    required SubmitOtpRequestDto request,
  });

  Future<AuthDto> completeSignUp({
    required CompleteSignUpRequestDto request,
  });
}
