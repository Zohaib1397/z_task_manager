abstract class DAO<T> {
  bool createTask(T task);
  T searchTask(String title);
  Future<List<T>> getAllTasks();
  bool updateTask(T task);
  bool deleteTask(T task);
}