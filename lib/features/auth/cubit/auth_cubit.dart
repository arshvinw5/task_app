import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/services/sp_service.dart';
import 'package:task_app/features/auth/repository/auth_local_repository.dart';
import 'package:task_app/features/auth/repository/auth_remote_repository.dart';
import 'package:task_app/models/user_model.dart';

//part or part of -> treated as one file

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();
  final AuthLocalRepository authLocalRepository = AuthLocalRepository();

  final SpService spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());

      final userModel = await authRemoteRepository.getUserData();

      if (userModel != null) {
        //we have add insert user in login fucntion
        //but we need updated user data
        //that why add this code to in get user data function
        //If you don’t update your local database with insertUser(userModel) again, you’ll be stuck with stale/old data from the login time.
        await authLocalRepository.insertUser(userModel);
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

      //setting the toke over here
      //save token
      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      //to save instert user to loacl db
      await authLocalRepository.insertUser(userModel);

      //making user object for stay in state
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
