import 'package:bitkub_test/domain/entities/auth.dart';

abstract class TokenRepository {
  Future<void> saveAuth(Auth auth);

  Future<Auth?> readAuth();

  Future<void> clear();
}
