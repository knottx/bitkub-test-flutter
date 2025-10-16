import 'package:bitkub_test/data/dtos/requests/complete_sign_up_request_dto.dart';
import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';

class CompleteSignUpRequestMapper {
  CompleteSignUpRequestMapper._();

  static CompleteSignUpRequestDto toDto(CompleteSignUpRequest entity) {
    return CompleteSignUpRequestDto(
      signUpToken: entity.signUpToken,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
    );
  }
}
