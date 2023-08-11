import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:z_task_manager/structure/TaskDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../structure/Task.dart';

import '../constants/reusable_ui.dart';
import '../structure/CATEGORY.dart';

class TaskHandler implements TaskDAO {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  @override
  bool createTask(task) {
    try {
      _fireStore.collection('tasks').add({
        'email': _auth.currentUser!.email,
        'title': task.text,
        'description': task.description,
        'status': task.isCompleted,
        'year': task.dueDate.year,
        'month': task.dueDate.month,
        'day': task.dueDate.day,
        'hour': task.dueDate.hour,
        'minute': task.dueDate.minute,
        'color': task.color.toString(),
        'category': task.category.toString()
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  bool deleteTask(task) {
    try{
      _fireStore.collection('tasks').doc(task.id).delete();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  bool deleteTaskAtIndex(index) {
    // TODO: implement deleteTaskAtIndex
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getAllTasks() async {
    Completer<List<Task>> completer = Completer();
    bool completerCompleted = false;
    _fireStore.collection('tasks').snapshots().listen((snapshot){
      List<Task> taskList = [];
      final list = snapshot.docs;
      for (final task in list) {
        final email = task.data()['email'];
        if (email == _auth.currentUser!.email) {
          final text = task.data()['title'];
          final id = task.id;
          final description = task.data()['description'];
          print(text);
          final status = task.data()['status'];
          final year = task.data()['year'];
          final month = task.data()['month'];
          final day = task.data()['day'];
          final hour = task.data()['hour'];
          final minute = task.data()['minute'];
          final color = task.data()['color'];
          final category = task.data()['category'];
          DateTime dateTime = DateTime(year, month, day, hour, minute);
          CATEGORY taskCategory;
          if (category == "CATEGORY.BASIC")
            taskCategory = CATEGORY.BASIC;
          else if (category == "CATEGORY.URGENT")
            taskCategory = CATEGORY.URGENT;
          else if (category == "CATEGORY.IMPORTANT")
            taskCategory = CATEGORY.IMPORTANT;
          else {
            taskCategory = CATEGORY.BASIC;
            print("Something wrong with category structure");
          }
          String hexColor =
          color.substring(8, 16); // Extract the hex color part
          int hexValue = int.parse(hexColor, radix: 16);
          Color taskColor = Color(hexValue);
          Task userTask =
          Task(text, description, status, dateTime, taskColor, taskCategory);
          userTask.id = id;
          taskList.add(userTask);
        }
      }
      if (!completerCompleted) {
        completer.complete(taskList);
        completerCompleted = true; // Mark the completer as completed
      }
    });
    return completer.future;
  }

  @override
  searchTask(title) {
    // TODO: implement searchTask
    throw UnimplementedError();
  }

  @override
  bool searchTaskAtIndex(index) {
    // TODO: implement searchTaskAtIndex
    throw UnimplementedError();
  }

  @override
  bool updateTask(task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
