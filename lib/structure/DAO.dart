abstract class DAO<T> {
  Future<bool> create(T task);
  Future<T> search(String title);
  Future<List<T>> getAll();
  Future<bool> update(T task);
  Future<bool> delete(T task);
}