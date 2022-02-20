import 'position.dart';

/// Model for a puzzle tile.
class Tile {
  /// {@macro tile}
  const Tile({
    required this.value,
    required this.currentValue,
    required this.position,
    this.isWhitespace = false,
  });

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  final int currentValue;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position position;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  @override
  String toString() =>
      "value: $value, position: (${position.x}, ${position.y}), currentValue: $currentValue, isWhitespace: $isWhitespace";
}
