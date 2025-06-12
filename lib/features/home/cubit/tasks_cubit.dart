import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_remote_repository.dart';
import 'package:task_app/models/task_model.dart';

part "tasks_state.dart";

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskRemoteRepository taskRemoteRepository = TaskRemoteRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(TaskLoading());

      //we are using that rgbToHex function to convert color to hex

      final taskModel = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );

      //final tasks = await taskRemoteRepository.fetchAllTasks(token: token);

      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      emit(TaskError(e.toString()));
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
