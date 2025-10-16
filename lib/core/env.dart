final class Env {
  Env._();
  static const String keyAuth = String.fromEnvironment(
    'KEY_AUTH',
    defaultValue: 'key_auth',
  );

  static const String aadAuth = String.fromEnvironment(
    'AAD_AUTH',
    defaultValue: 'auth:v1',
  );
}
