import 'package:bitkub_test/data/dtos/sign_up_token_dto.dart';
import 'package:bitkub_test/domain/entities/sign_up_token.dart';

class SignUpTokenMapper {
  SignUpTokenMapper._();

  static SignUpToken toEntity(SignUpTokenDto dto) {
    return SignUpToken(
      token: dto.token,
    );
  }
}
