import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/models/user_model.dart';

class AuthRemoteRepository {
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
      return UserModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> login() async {}
}
