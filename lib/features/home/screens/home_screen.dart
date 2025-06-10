import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/core/constants/utils.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Tasks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.add), onPressed: () {}),
        ],
        //centerTitle: true,
      ),
      body: Column(
        children: [
          DateSelector(),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                  color: Colors.amberAccent,
                  headerText: 'Header Text',
                  descriptionText:
                      'This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,This is a task,',
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: strenthColor(Colors.amberAccent, 0.68),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('10.00pm', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
