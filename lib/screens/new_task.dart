import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/constants/constants.dart';
import 'dart:io' show IOException, Platform;
import 'package:intl/intl.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import 'package:z_task_manager/structure/TextFieldHandler.dart';

import '../constants/reusable_ui.dart';
import '../structure/Category.dart';
import '../structure/Task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  static const String id = "NewTask_Screen";

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final taskTitle = TextFieldHandler();


  //This following Date Variable is the controller of Deadline/ Due Date TextField
  final date = TextFieldHandler();
  DateTime storeDateTime = DateTime.now();

  //The color of task variable changes dynamically upon user selection
  Color currentTaskColor = const Color(0xffffc107);

  //The current category/type of the task
  CATEGORY _category = CATEGORY.BASIC;

  //Following function is to show the relevant date time picker for IOS and android
  void showDateTimePicker() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 300.0,
            color: CupertinoColors.white,
            child: Column(
              children: [
                Container(
                  height: 50.0,
                  color: CupertinoColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        storeDateTime = dateTime;
                        date.controller.text =
                            "${DateFormat.yMMMMEEEEd().format(dateTime)} (${DateFormat.jm().format(dateTime)})";
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      var _chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      TimeOfDay? _chosenTime;
      if (_chosenDate != null) {
        _chosenTime = await showTimePicker(
            context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
      }
      if (_chosenTime != null && _chosenDate != null) {
        _chosenDate = _chosenDate.copyWith(
          hour: _chosenTime.hour,
          minute: _chosenTime.minute,
        );
        storeDateTime = _chosenDate;
        date.controller.text =
            "${DateFormat.yMMMMEEEEd().format(_chosenDate)} (${DateFormat.jm().format(_chosenDate)})";
        setState(() => date.errorText = "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "New Task",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Top Task system and every thing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My New Task",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: taskTitle.controller,
                  minLines: 1,
                  maxLines: 2,
                  style: kDefaultTaskTitleStyle,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Type your task here",
                      errorText: taskTitle.errorText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.circle,
                          color: currentTaskColor,
                        ),
                        onPressed: () {
                          ColorPicker(
                            color: currentTaskColor,
                            onColorChanged: (Color) {
                              setState(() {
                                currentTaskColor = Color;
                              });
                            },
                          ).showPickerDialog(
                            context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          );
                        },
                      )),
                  onChanged: (value) => setState(() => taskTitle.errorText = ""),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Deadline",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  readOnly: true,
                  style: kDefaultTaskTitleStyle,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: "Click calendar to select ->",
                    errorText: date.errorText,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        showDateTimePicker();
                        setState(() {
                          // if(date.val)
                        });
                      },
                    ),
                  ),
                  controller: date.controller,
                  onChanged: (value) {
                    setState(() {
                      date.errorText = "";
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Type",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedCategoryButton(
                        text: "Basic",
                        isSelected: _category == CATEGORY.BASIC ? true : false,
                        onPressed: () =>
                            setState(() => _category = CATEGORY.BASIC)),
                    RoundedCategoryButton(
                        text: "Urgent",
                        isSelected: _category == CATEGORY.URGENT ? true : false,
                        onPressed: () =>
                            setState(() => _category = CATEGORY.URGENT)),
                    RoundedCategoryButton(
                        text: "Important",
                        isSelected:
                            _category == CATEGORY.IMPORTANT ? true : false,
                        onPressed: () =>
                            setState(() => _category = CATEGORY.IMPORTANT)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.black26,
                  height: 1.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                //add more fields here if required
              ],
            ),
            //Bottom Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        try{
                          if(taskTitle.controller.text == "" || date.controller.text == ""){
                            setState(() {
                              if(taskTitle.controller.text=="") {taskTitle.errorText = "Cannot have empty task";}
                              if(date.controller.text=="") {date.errorText = "Cannot have empty Deadline";}
                            });
                            return;
                          }
                          final createTask = Task(taskTitle.controller.text, false, storeDateTime, currentTaskColor, _category);
                          Provider.of<TaskControllerProvider>(context, listen: false).addTaskToList(createTask);
                          Navigator.pop(context);
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Save Task",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
