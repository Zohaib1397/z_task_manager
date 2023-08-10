import 'package:z_task_manager/structure/DAO.dart';

abstract class TaskDAO<T> extends DAO<T>{
  bool deleteTaskAtIndex(int index);
  bool searchTaskAtIndex(int index);
}