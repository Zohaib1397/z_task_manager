import 'package:flutter/material.dart';
import 'package:z_task_manager/handlers/task_handler.dart';

import '../structure/Task.dart';

class TaskControllerProvider extends ChangeNotifier{
    final taskHandler = TaskHandler();

    List<Task> tasksList = [];

    TaskControllerProvider(){
        tasksFromHandler();
    }

    Future<void> tasksFromHandler()async{
        tasksList = await taskHandler.getAll();
        notifyListeners();
    }

    void clearForDispose(){
        tasksList.clear();
        notifyListeners();
    }

    bool removeTaskFromList(Task task){
        try{
            taskHandler.delete(task);
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
            taskHandler.create(task);
            tasksList.add(task);
            notifyListeners();
            return true;
        }catch(e){
            print(e.toString());
            return false;
        }
    }
}