import 'package:bitkub_test/data/dtos/user_dto.dart';
import 'package:bitkub_test/data/repositories/user_repository_impl.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockUserRemoteDataSource mockRemote;
  late UserRepositoryImpl repo;

  setUp(() {
    mockRemote = MockUserRemoteDataSource();
    repo = UserRepositoryImpl(mockRemote);
  });

  group('UserRepositoryImpl.me', () {
    test('returns Result.success when remote call succeeds', () async {
      const dto = UserDto(
        id: 'u1',
        firstName: 'Knot',
        lastName: 'Tippun',
        phoneNumber: '+66999999999',
      );

      when(
        mockRemote.me(),
      ).thenAnswer((_) async => dto);

      final result = await repo.me();

      expect(result, isA<Result<User>>());
      result.when(
        onSuccess: (user) {
          expect(user.id, 'u1');
          expect(user.firstName, 'Knot');
          expect(user.lastName, 'Tippun');
        },
        onFailure: (_) => fail('Expected success but got failure'),
      );
      verify(mockRemote.me()).called(1);
    });

    test('returns Result.failure when remote throws AppError', () async {
      when(
        mockRemote.me(),
      ).thenAnswer((_) async => throw const AppError('Network error'));

      final result = await repo.me();

      result.when(
        onSuccess: (_) => fail('Expected failure but got success'),
        onFailure: (e) => expect(e.toString(), contains('Network error')),
      );
    });
  });
}
