import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/utils.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffSet = 0;
  DateTime selctedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffSet);
    String monthName = DateFormat("MMMM").format(weekDates.first);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffSet--;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                monthName,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffSet++;
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDates.length,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                bool isSelected =
                    DateFormat('d').format(selctedDate) ==
                        DateFormat('d').format(date) &&
                    selctedDate.month == date.month &&
                    selctedDate.year == date.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selctedDate = date;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepOrangeAccent : null,
                      border: Border.all(color: Colors.grey.shade100, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 26,
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
