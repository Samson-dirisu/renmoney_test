abstract class Storage {
  /// clears the storage
  Future<void> clear();

  Future<void> saveList<T>(String key, List<T> value);

  Future<List<T>?> getList<T>(String key);
}
