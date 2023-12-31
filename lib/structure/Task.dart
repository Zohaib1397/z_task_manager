import 'package:flutter/material.dart';
import 'CATEGORY.dart';



class Task{
  late String _id;
  late String _text;
  late String _description;
  late bool _isCompleted;
  late DateTime _dueDate;
  late Color _color;
  late CATEGORY _category;
  // late DateTime timeStamp;

  Task(this._text,this. _description, this._isCompleted, this._dueDate, this._color,
      this._category);

  CATEGORY get category => _category;

  String getCategory(){
    if(_category == CATEGORY.BASIC) {
      return "Basic";
    } else if(_category == CATEGORY.IMPORTANT) {
      return "Important";
    } else {
      return "Urgent";
    }
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  set category(CATEGORY value) {
    _category = value;
  }

  String get description => _description;
  set description(String value) {
    _description = value;
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  DateTime get dueDate => _dueDate;

  set dueDate(DateTime value) {
    _dueDate = value;
  }

  bool get isCompleted => _isCompleted;

  set isCompleted(bool value) {
    _isCompleted = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }
}