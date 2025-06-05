part of 'auth_cubit.dart';

//we have made this file to support auth cubit

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authregister extends AuthState {}

final class AuthLoggedIn extends AuthState {
  final UserModel user;

  AuthLoggedIn(this.user);
}

final class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}
