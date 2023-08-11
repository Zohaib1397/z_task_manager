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

    void clearForDispose(){
        tasksList.clear();
        notifyListeners();
    }

    bool removeTaskFromList(Task task){
        try{
            taskHandler.deleteTask(task);
            tasksList.remove(task);
            notifyListeners();
            return true;
        }catch(e){
            print(e.toString());
            return false;
        }
    }

    bool addTaskToList(Task task){
        try{
            taskHandler.createTask(task);
            tasksFromHandler();
            notifyListeners();
            return true;
        }catch(e){
            print(e.toString());
            return false;
        }
    }
}