import 'dart:math';

import 'package:bitkub_test/data/api_client/api_client.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';

class ApiClientDemo implements ApiClient {
  final SessionStore _sessionStore;

  Map<String, Map<String, dynamic>> users = {};

  ApiClientDemo(this._sessionStore);

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final auth = await _sessionStore.readAuth();
    final accessToken = auth?.accessToken;

    switch (path) {
      case '/users/me':
        if (accessToken != null && accessToken.isNotEmpty) {
          final phoneNumber = accessToken.replaceFirst(r'access_token_', '');
          users.putIfAbsent(accessToken, () => _mockUserJson(phoneNumber));
          return users[accessToken]!;
        }

        throw const AppError('Unauthorized');

      default:
        throw AppError('Get request to $path failed');
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    switch (path) {
      case '/auth/signin':
        if (data != null &&
            data['phoneNumber'] == '123456789' &&
            data['password'] == 'password') {
          final phoneNumber = data['phoneNumber'] as String;
          final accessToken = _mockAccessToken(phoneNumber);
          users.putIfAbsent(accessToken, () => _mockUserJson(phoneNumber));
          return {'accessToken': accessToken};
        }

        throw const AppError('Invalid phone number or password');

      case '/auth/signout':
        final auth = await _sessionStore.readAuth();
        final accessToken = auth?.accessToken;
        if (accessToken != null && accessToken.isNotEmpty) {
          users.remove(accessToken);
          return {};
        }

        throw const AppError('Unauthorized');

      case '/auth/signup':
        if (data != null && data['phoneNumber'] != null) {
          return {'ref': randomOtpRef()};
        }

        throw const AppError('Invalid request data');

      case '/auth/submit-otp':
        if (data != null &&
            data['phoneNumber'] != null &&
            data['otp'] != null) {
          final phoneNumber = data['phoneNumber'] as String;
          return {'token': 'sign_up_token_$phoneNumber'};
        }

        throw const AppError('Invalid request data');

      case '/auth/complete-signup':
        if (data != null &&
            data['signUpToken'] != null &&
            data['phoneNumber'] != null &&
            data['password'] != null) {
          final phoneNumber = data['phoneNumber'] as String;
          final accessToken = _mockAccessToken(phoneNumber);
          users.putIfAbsent(accessToken, () => _mockUserJson(phoneNumber));
          return {'accessToken': accessToken};
        }

        throw const AppError('Invalid request data');
      default:
        throw AppError('Get request to $path failed');
    }
  }

  String randomOtpRef() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _mockAccessToken(String phoneNumber) {
    return 'access_token_$phoneNumber';
  }

  Map<String, dynamic> _mockUserJson(String phoneNumber) {
    return {
      'firstName': 'John',
      'lastName': 'Doe',
      'phoneNumber': phoneNumber,
    };
  }
}
