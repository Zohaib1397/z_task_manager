import 'package:flutter/material.dart';
import 'package:z_task_manager/handlers/task_handler.dart';
import 'package:z_task_manager/structure/CATEGORY.dart';

import '../structure/Task.dart';

class TaskControllerProvider extends ChangeNotifier{
    //TODO create taskHandler object over here
    final taskHandler = TaskHandler();

    List<Task> tasksList = [];

    TaskControllerProvider(){
        tasksFromHandler();
    }

    Future<void> tasksFromHandler()async{
        tasksList = await taskHandler.getAllTasks();
        notifyListeners();
    }


    bool addTaskToList(Task task){
        taskHandler.createTask(task);
        notifyListeners();
        return true;
    }
}