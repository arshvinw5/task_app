import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/repository/auth_remote_repository.dart';
import 'package:task_app/models/user_model.dart';

//part or part of -> treated as one file

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();

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
}
