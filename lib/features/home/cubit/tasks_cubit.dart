import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/features/home/repository/task_remote_repository.dart';
import 'package:task_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

part "tasks_state.dart";

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskRemoteRepository taskRemoteRepository = TaskRemoteRepository();

  //to upload taks to offline databse
  final TaskLocalRepository taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
    required String uId,
  }) async {
    try {
      emit(TaskLoading());

      //we are using that rgbToHex function to convert color to hex

      final taskModel = await taskRemoteRepository.createTask(
        uId: uId,
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );

      //final tasks = await taskRemoteRepository.fetchAllTasks(token: token);

      //to insert task to local db
      await taskLocalRepository.insertTask(taskModel);

      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      // print("Error in createTask(): $e");

      // // In offline mode, get all tasks including the newly created one
      // final tasks = await taskLocalRepository.getTask();

      // if (tasks.isNotEmpty) {
      //   // Show all tasks including the new offline task
      //   emit(getTasksSuccess(tasks));
      // } else {
      //   emit(TaskError(e.toString()));
      // }

      print("Error in createTask(): $e");

      try {
        // Create offline task directly here instead of fetching all tasks
        final offlineTask = TaskModel(
          id: const Uuid().v6(),
          uId: uId,
          title: title,
          description: description,
          hexColor: color,
          dueAt: dueAt,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: 0, // Mark as not synced
        );

        // Save to local DB
        await taskLocalRepository.insertTask(offlineTask);

        // Emit success with the offline task
        emit(AddNewTaskSuccess(offlineTask));
      } catch (localError) {
        emit(TaskError(localError.toString()));
      }
    }
  }

  //to fetch all the tasks
  Future<void> fetchAllTasks({required String token}) async {
    try {
      emit(TaskLoading());

      //we are using that rgbToHex function to convert color to hex

      final tasks = await taskRemoteRepository.fetchAllTasks(token: token);

      emit(getTasksSuccess(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
