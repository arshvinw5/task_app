import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/services/sp_service.dart';
import 'package:task_app/features/auth/repository/auth_remote_repository.dart';
import 'package:task_app/models/user_model.dart';

//part or part of -> treated as one file

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();

  final SpService spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());

      final userModel = await authRemoteRepository.getUserData();

      if (userModel != null) {
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.registor(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      emit(Authregister());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      //save token

      //making user object for stay in state
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
