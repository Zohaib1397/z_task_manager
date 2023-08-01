abstract class DAO<T> {
  bool createTask(task);
  T searchTask(title);
  List<T> getAllTasks();
  bool updateTask(task);
  bool deleteTask(task);
}