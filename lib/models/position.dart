/// {@template position}
/// 2-dimensional position model.
///
/// (1, 1) is the top left corner of the board.
/// {@endtemplate}
class Position implements Comparable<Position> {
  /// {@macro position}
  const Position({required this.x, required this.y});

  /// The x position.
  final int x;

  /// The y position.
  final int y;

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && x == other.x && y == other.y;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x.hashCode ^ y.hashCode;

  Position copyWith({
    int? x,
    int? y,
  }) {
    return Position(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
