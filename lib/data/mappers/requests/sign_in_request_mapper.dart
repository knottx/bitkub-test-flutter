import 'package:bitkub_test/data/dtos/requests/sign_in_request_dto.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';

class SignInRequestMapper {
  SignInRequestMapper._();

  static SignInRequestDto toDto(SignInRequest entity) {
    return SignInRequestDto(
      phoneNumber: entity.phoneNumber,
      password: entity.password,
    );
  }
}
