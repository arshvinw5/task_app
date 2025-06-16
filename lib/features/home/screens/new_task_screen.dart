import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/components/auth_button.dart';
import 'package:task_app/features/auth/cubit/auth_cubit.dart';
import 'package:task_app/features/home/cubit/tasks_cubit.dart';
import 'package:task_app/features/home/screens/home_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen());
  const AddNewTaskScreen({super.key});

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<AddNewTaskScreen> {
  final formKey = GlobalKey<FormState>();
  //controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Color selectedColor = Colors.amberAccent;

  //to create a new task
  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      //to get the token we can use auth cubit
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;

      await context.read<TaskCubit>().createTask(
        uId: user.user.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        color: selectedColor,
        token: user.user.token,
        dueAt: selectedDate,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Add Task ?')),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AddNewTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task Created Successfully')),
            );

            //the reason why init state in home screen didn't work
            //Navigator.pop(context);
            //that's pop back to home screenn and it didn't tryigger the init state fucntion
            //to fetch all the task from backend

            //to return back to Home screen
            //It pushes HomeScreen to the top and removes
            //all previous screens from the stack. So now the stack
            Navigator.pushAndRemoveUntil(
              context,
              HomeScreen.route(),
              (_) => false,
            );

            //A predicate is just a function that
            //returns a boolean (true or false). In this
            //context, it tells Flutter which routes to keep in
            //the navigation stack.
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Form(
              key: formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Date : ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final _selectedDate =
                                          await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                              const Duration(days: 365),
                                            ),
                                          );
                                      if (_selectedDate != null) {
                                        setState(() {
                                          selectedDate = _selectedDate;
                                        });
                                      }
                                    },
                                    child: Text(
                                      DateFormat(
                                        'MM-dd-yyyy',
                                      ).format(selectedDate),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Title is required';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.black),
                                controller: titleController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Title',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Description is required';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.black),
                                controller: descriptionController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Description',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ColorPicker(
                                selectedPickerTypeColor: Colors.white,
                                heading: const Text('Pick a color ?'),
                                subheading: const Text(
                                  'Select a different shade',
                                ),
                                color: selectedColor,
                                pickersEnabled: {ColorPickerType.wheel: true},
                                onColorChanged: (Color color) {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                              ),
                              const Spacer(),
                              AuthButton(
                                text: 'Submit',
                                onTap: createNewTask,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
