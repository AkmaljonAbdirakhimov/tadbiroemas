part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

final class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({
    required this.email,
    required this.password,
  });
}

final class LogoutEvent extends AuthEvent {}

final class CheckTokenExpiryEvent extends AuthEvent {}
