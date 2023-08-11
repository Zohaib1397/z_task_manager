import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import '../../constants/constants.dart';
import '../../structure/Task.dart';



class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskData,
  });
  final Task taskData;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.taskData.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black.withAlpha(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.taskData.getCategory(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    minSize: 35,
                    color: Colors.black,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(Icons.edit_note),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  widget.taskData.text,
                  style: kDefaultTaskTitleStyle),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Long long description details",

              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(
                  //   children: [
                  //     const Icon(
                  //       Icons.watch_later_outlined,
                  //       size: 15,
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text("Reminder Feature Require here"),
                  //   ],
                  // ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(DateFormat.yMMMd('en-US').format(widget.taskData.dueDate)),
                    ],
                  ),
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: CircleBorder(),
                    value: widget.taskData.isCompleted,
                    onChanged: (value) async {
                      setState(() {
                        widget.taskData.isCompleted = !widget.taskData.isCompleted;
                      });
                      await Future.delayed(Duration(milliseconds: 300));
                      setState((){
                        Provider.of<TaskControllerProvider>(context,listen: false).notifyListeners();
                      });
                    },
                  ),
                ],
              ),

            ],
          ),

        ),
      ),
    );
  }
}
