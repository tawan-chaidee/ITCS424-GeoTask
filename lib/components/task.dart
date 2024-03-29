import 'package:flutter/material.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:geotask/page/detail_page.dart';
import 'package:geotask/provider/todo_provider.dart';
// import 'package:geotask_mainpage/store/taskslist.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// class Task {
//   final String? title;
//   final String? description;
//   final DateTime dateTime;
//   final String? location;
//   final bool isDone;

//   Task({Key? key, this.title, this.description, required this.dateTime, this.location, this.isDone = false});
// }

// typedef TasksList = Map<DateTime, List<Task>>;

class TaskTile extends StatelessWidget {
  // final int taskIndex;
  // final DateTime taskDate;
  // final int taskIndex;
  final Todo task;
  final DateTime taskDate;
  final int taskIndex;

  TaskTile({required this.task, required this.taskDate, required this.taskIndex});

  @override
  Widget build(BuildContext context) {
    // String? formattedTime = task.dateTime?.toLocal().toString();
    var format = DateFormat.Hm();
    String? formattedTime =
        task.startTime != null ? format.format(task.startTime!) : null;
    bool isPast = task.startTime!.isBefore(DateTime.now());

    return Consumer<TodoProvider>(builder: (context, tasksListModel, child) {
      return Container(
          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isPast
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TodoDetailPage(
                        todoIndex: taskIndex,
                        // taskDate: taskDate,
                        // taskIndex: taskIndex,
                      ),
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          formattedTime != null
                              ? Text(formattedTime,
                                  style: Theme.of(context).textTheme.labelLarge)
                              : Container(),
                          SizedBox(width: 4),
                          task.locationName != null
                              ? Icon(Icons.location_on,
                                  size: 16, color: Colors.black)
                              : Container(),
                          task.locationName != null
                              ? Text(task.locationName!,
                                  style: Theme.of(context).textTheme.labelLarge)
                              : Container(),
                        ],
                      ),
                      task.title != null
                          ? Text(task.title!,
                              style: Theme.of(context).textTheme.titleLarge)
                          : Container(),
                      task.subtitle != null
                          ? Text(task.subtitle!,
                              style: Theme.of(context).textTheme.bodyLarge,overflow: TextOverflow.ellipsis,
                              )
                          : Container(),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  print('Delete task');
                },
              )
            ],
          ));
    });
  }
}
