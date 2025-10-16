import 'package:bitkub_test/domain/entities/auth.dart';

abstract class SessionStore {
  Future<void> saveAuth(Auth auth);

  Future<Auth?> readAuth();

  Future<void> clear();
}
