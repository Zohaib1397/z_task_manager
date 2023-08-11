import 'package:flutter/material.dart';
import 'package:z_task_manager/handlers/task_handler.dart';
import 'package:z_task_manager/structure/CATEGORY.dart';

import '../structure/Task.dart';

class TaskControllerProvider extends ChangeNotifier{
    final taskHandler = TaskHandler();

    List<Task> tasksList = [];

    TaskControllerProvider(){
        tasksFromHandler();
        // sortListBasedOnTime();
    }

    Future<void> tasksFromHandler()async{
        tasksList = await taskHandler.getAllTasks();
        notifyListeners();
    }

    void clearForDispose(){
        tasksList.clear();
        notifyListeners();
    }

    void sortListBasedOnTime(){
        tasksList.sort((a,b) => a.dueDate.compareTo(b.dueDate));
        tasksList = tasksList.reversed.toList();
        notifyListeners();
    }

    bool removeTaskFromList(Task task){
        try{
            taskHandler.deleteTask(task);
            tasksList.remove(task);
            // sortListBasedOnTime();
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
            // sortListBasedOnTime();
            notifyListeners();
            return true;
        }catch(e){
            print(e.toString());
            return false;
        }
    }
}