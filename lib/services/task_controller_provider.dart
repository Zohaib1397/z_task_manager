import 'package:flutter/material.dart';
import 'package:z_task_manager/structure/Category.dart';

import '../structure/Task.dart';

class TaskControllerProvider extends ChangeNotifier{
    //TODO create taskHandler object over here

    List<Task> tasksList = [];

    TaskControllerProvider(){
        tasksList.add(Task("Submit Internship Joining Letter", false, DateTime.now(), Colors.blue, CATEGORY.BASIC));
    }

    bool addTaskToList(Task task){
        tasksList.add(task);
        notifyListeners();
        return true;
    }
}