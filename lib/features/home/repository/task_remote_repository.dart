import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/models/task_model.dart';

class TaskRemoteRepository {
  //save task in db
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.bankendUri}/tasks/create'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );

      if (res.statusCode != 201) {
        //conver this to map then pass the error message
        throw jsonDecode(res.body)['error'];
      }

      return TaskModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      rethrow;
    }
  }

  //to fetch all the task related to user

  Future<List<TaskModel>> fetchAllTasks({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse('${Constants.bankendUri}/tasks/fetch'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      final listTask = jsonDecode(res.body);
      List<TaskModel> taskList = [];

      print(listTask);

      for (var task in listTask) {
        taskList.add(TaskModel.fromMap(task));
      }

      return taskList;
    } catch (e) {
      rethrow;
    }
  }
}
