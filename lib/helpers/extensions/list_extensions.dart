extension ListExtensions<T> on List<T> {
  List<List<T>> chunk(int chunkSize) {
    assert(chunkSize > 0);
    final result = <List<T>>[];
    for (var i = 0; i < length; i += chunkSize) {
      result.add(sublist(i, i + chunkSize));
    }
    return result;
  }
}
