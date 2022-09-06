extension MostPopularItemsExtension<E> on Iterable<E> {
  /// Returns the most popular items, where all items in the returned
  /// list have the same number of occurances. If [this] is empty, returns an
  /// empty list
  ///
  /// Examples:
  ///   `[1,2,3,2].mostPopularItems() == [2]`
  ///   `[1,1,2,2].mostPopularItems() == [1,2]`
  Iterable<E> mostPopularItems() {
    if (isEmpty) return [];
    final itemsCounted = <E, int>{};
    for (final e in this) {
      if (itemsCounted.containsKey(e)) {
        itemsCounted[e] = itemsCounted[e] + 1;
      } else {
        itemsCounted[e] = 1;
      }
    }
    final highestCount = (itemsCounted.values.toList()..sort()).last;
    return itemsCounted.entries
        .where((e) => e.value == highestCount)
        .map((e) => e.key);
  }
}
