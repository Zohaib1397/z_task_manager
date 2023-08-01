import 'package:flutter/cupertino.dart';

class TextFieldHandler{
  late String value;
  late String errorText;
  late TextEditingController controller;
  TextFieldHandler(){
    value = "";
    errorText = "";
    controller = TextEditingController();
  }
}