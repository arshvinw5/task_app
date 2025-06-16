import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/core/services/sp_service.dart';
import 'package:task_app/features/auth/repository/auth_local_repository.dart';
import 'package:task_app/models/user_model.dart';

class AuthRemoteRepository {
  final SpService spService = SpService();
  final AuthLocalRepository authLocalRepository = AuthLocalRepository();
  Future<UserModel> registor({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.bankendUri}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      //long way ->
      //return UserModel.fromMap(jsonDecode(res.body));

      //short way
      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.bankendUri}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      //success code 200
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  //to get the user data to validate the token
  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();

      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse('${Constants.bankendUri}/auth/tokenIsValid'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      //to get the user data from backend
      final userResponse = await http.get(
        Uri.parse('${Constants.bankendUri}/auth'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }
      return UserModel.fromMap(jsonDecode(userResponse.body));
    } catch (e) {
      final user = await authLocalRepository.getUser();
      return user;
    }
  }
}
