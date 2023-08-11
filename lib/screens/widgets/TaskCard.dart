import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import '../../constants/constants.dart';
import '../../structure/Task.dart';
import '../new_task.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskData,
  });

  final Task taskData;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _editButtonActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.taskData.color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategory_EditButtonRow(context),
            _addSpace(10),
            _buildTextWithStyle(
                widget.taskData.text, kDefaultTaskTitleStyle),
            _addSpace(10),
            _buildTextWithStyle(widget.taskData.description, null),
            _addSpace(10),
            _buildDueDate_CheckBoxRow(context),
          ],
        ),
      ),
    );
  }

  Row _buildDueDate_CheckBoxRow(BuildContext context) {
    return Row(
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
            Text("${DateFormat.yMMMEd().format(widget.taskData.dueDate)} (${DateFormat.jm().format(widget.taskData.dueDate)})"),
          ],
        ),
        Checkbox(
          activeColor: Colors.black,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: CircleBorder(),
          value: widget.taskData.isCompleted,
          onChanged: (value) async {
            setState(() {
              widget.taskData.isCompleted = !widget.taskData.isCompleted;
            });
            await Future.delayed(Duration(milliseconds: 300));
            setState(() {
              Provider.of<TaskControllerProvider>(context, listen: false)
                  .notifyListeners();
            });
          },
        ),
      ],
    );
  }

  SizedBox _addSpace(double size) => SizedBox(height: size);

  Text _buildTextWithStyle(String text, TextStyle? style) =>
      Text(text, style: style);

  Row _buildCategory_EditButtonRow(BuildContext context) {
    return Row(
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
          borderRadius: _editButtonActive? BorderRadius.all(Radius.circular(16.0)) : BorderRadius.all(Radius.circular(8.0)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewTaskScreen(task: widget.taskData)));
          },
          child: const Icon(Icons.edit_note),
        ),
      ],
    );
  }
}
