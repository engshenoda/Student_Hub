import 'package:meta/meta.dart';

@immutable
abstract class CareerRoleState {}

class CareerRoleInitial extends CareerRoleState {}

class CareerRoleLoading extends CareerRoleState {}

class CareerRoleLoaded extends CareerRoleState {
  final String? selectedRole;
  CareerRoleLoaded(this.selectedRole);
}

class CareerRoleUploading extends CareerRoleState {}

class CareerRoleError extends CareerRoleState {
  final String message;
  CareerRoleError(this.message);
}
