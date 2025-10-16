import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';
import 'package:bitkub_test/domain/entities/sign_up_token.dart';
import 'package:bitkub_test/domain/utils/result.dart';

abstract class AuthRepository {
  Future<Result<Auth>> signIn({
    required SignInRequest request,
  });

  Future<Result<Unit>> signOut();

  Future<Result<OtpRef>> signUp({
    required SignUpRequest request,
  });

  Future<Result<SignUpToken>> submitOtp({
    required SubmitOtpRequest request,
  });

  Future<Result<Auth>> completeSignUp({
    required CompleteSignUpRequest request,
  });
}
