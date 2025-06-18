import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/auth/cubit/auth_cubit.dart';
import 'package:task_app/features/home/cubit/tasks_cubit.dart';
import 'package:task_app/features/home/screens/new_task_screen.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomeScreen());

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selctedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    //fetch the user to get the token
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    // context.read<TaskCubit>().fetchAllTasks(token: user.user.token);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      context.read<TaskCubit>().fetchAllTasks(token: user.user.token);
    });

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        //print('We are on WiFi');

        // ignore: use_build_context_synchronously
        await context.read<TaskCubit>().unsyncedTasks(user.user.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, AddNewTaskScreen.route());
        },

        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('My Tasks')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskError) {
            return Center(child: Text(state.error));
          }

          if (state is getTasksSuccess) {
            final taskList =
                state.taskList
                    .where(
                      (elem) =>
                          DateFormat('d').format(elem.dueAt) ==
                              DateFormat('d').format(selctedDate) &&
                          selctedDate.month == elem.dueAt.month &&
                          selctedDate.year == elem.dueAt.year,
                    )
                    .toList();
            return Column(
              children: [
                DateSelector(
                  selctedDate: selctedDate,
                  onTap: (date) {
                    setState(() {
                      selctedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      final task = taskList[index];
                      return Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                              color: task.hexColor,
                              headerText: task.title,
                              descriptionText: task.description,
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: strenthColor(task.hexColor, 0.68),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat.jm().format(task.dueAt),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
