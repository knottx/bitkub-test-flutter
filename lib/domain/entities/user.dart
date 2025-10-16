import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phoneNumber,
  ];
}
