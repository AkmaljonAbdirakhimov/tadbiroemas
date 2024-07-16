part of 'auth_bloc.dart';

sealed class AuthState {}

final class InitialAuthState extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class AuthenticatedAuthState extends AuthState {
  final User user;

  AuthenticatedAuthState(this.user);
}

final class UnAuthenticatedAuthState extends AuthState {}

final class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState(this.message);
}
