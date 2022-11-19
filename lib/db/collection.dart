abstract class Collection<T> {
  /// Create and add the given object in this database
  Future<int> create(T object);

  /// Update the given object of this database
  Future<void> update(T object);

  /// Delete the specified object
  Future<void> delete(int object);

  /// Return the specified object, or null if it doesn't exist
  Future<Object?> get(int object);

  /// Return all objects in the database
  Future<List<T>> getAll();
}