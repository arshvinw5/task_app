part of "tasks_cubit.dart";

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskError extends TaskState {
  final String error;
  TaskError(this.error);
}

final class AddNewTaskSuccess extends TaskState {
  final TaskModel taskModel;
  const AddNewTaskSuccess(this.taskModel);
}

final class getTasksSuccess extends TaskState {
  final List<TaskModel> taskList;
  const getTasksSuccess(this.taskList);
}
