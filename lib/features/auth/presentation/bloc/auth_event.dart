part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}
class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpEvent({required this.name, required this.email, required this.password});
}
class GetCurrentUserEvent extends AuthEvent{}
class SignOutEvent extends AuthEvent {}
