import 'package:bitkub_test/data/dtos/requests/sign_up_request_dto.dart';
import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';

class SignUpRequestMapper {
  SignUpRequestMapper._();

  static SignUpRequestDto toDto(SignUpRequest entity) {
    return SignUpRequestDto(
      phoneNumber: entity.phoneNumber,
    );
  }
}
