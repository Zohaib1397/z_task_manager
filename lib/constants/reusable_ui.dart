import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../structure/Task.dart';
import 'constants.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.onPressed,
  });

  final Color backgroundColor;
  final AssetImage image;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 50,
      height: 50,
      color: backgroundColor,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: Image(
        image: image,
        width: 30,
        height: 30,
      ),
    );
  }
}


class RoundedCategoryButton extends StatelessWidget {
  const RoundedCategoryButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      color: isSelected ? Colors.black : Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            )),
      ),
    );
  }
}



class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskData,
  });
  final Task taskData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: taskData.color,
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
                          taskData.getCategory(),
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
                  taskData.text,
                  style: kDefaultTaskTitleStyle),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(DateFormat.yMMMd('en-US').format(taskData.dueDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Reminder Feature Require here"),
                    ],
                  ),
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: CircleBorder(),
                    value: taskData.isCompleted,
                    onChanged: (value) {},
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
