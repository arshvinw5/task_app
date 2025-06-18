import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
//import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/models/task_model.dart';
//import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  //to get all the task from locl db
  final TaskLocalRepository taskLocalRepository = TaskLocalRepository();
  //save task in db
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required DateTime dueAt,
    required String uId,
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
      //store the date in same sql db
      //creating a uid since it is a local db
      // try {
      //   final taskModel = TaskModel(
      //     id: const Uuid().v6(),
      //     uId: uId,
      //     title: title,
      //     description: description,
      //     hexColor: hexToColor(hexColor),
      //     dueAt: dueAt,
      //     createdAt: DateTime.now(),
      //     updatedAt: DateTime.now(),
      //     isSynced: 0,
      //   );
      //   await taskLocalRepository.insertTask(taskModel);

      //   return taskModel;
      // } catch (e) {
      //   rethrow;
      // }

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

      for (var task in listTask) {
        taskList.add(TaskModel.fromMap(task));
      }

      await taskLocalRepository.insertTasks(taskList);

      return taskList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTask();

      if (tasks.isNotEmpty) {
        return tasks;
      }

      //throw e = rethrow

      rethrow;
    }
  }

  //to update unsynced tasks
  Future<bool> syncTask({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskListInMap = [];

      for (final task in tasks) {
        // Convert each TaskModel to a map
        // because the API expects a list of maps
        taskListInMap.add(task.toMap());
      }

      final res = await http.post(
        Uri.parse('${Constants.bankendUri}/tasks/sync'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode(taskListInMap),
      );

      if (res.statusCode != 201) {
        //conver this to map then pass the error message
        throw jsonDecode(res.body)['error'];
      }

      return true;
    } catch (e) {
      print('Error in syncTask: $e');
      return false;
    }
  }
}
