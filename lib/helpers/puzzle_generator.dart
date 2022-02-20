import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/models.dart';

class PuzzleGenerator {
  /// Build a randomized, solvable puzzle of the given size.
  List<Tile> generate(int size) {
    final positions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          positions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          positions.add(position);
        }
      }
    }
    final values = List.generate((size * size) - 1, (index) => index + 1);
    // Randomize only the current tile positions.
    values.shuffle();

    var newTiles = _getTileListFromPositions(
      size,
      positions,
      values,
    );

    // Assign the tiles new current positions until the puzzle is solvable and
    // zero tiles are in their correct position.
    while (!isSolvable(newTiles) || getNumberOfCorrectTiles(newTiles) != 0) {
      values.shuffle();
      newTiles = _getTileListFromPositions(
        size,
        positions,
        values,
      );
    }

    if (kDebugMode) print(newTiles);

    return newTiles;
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable(List<Tile> tiles) {
    final size = sqrt(tiles.length).toInt();
    final height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions(tiles);

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhitespace);
    final whitespaceRow = whitespace.position.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.position.compareTo(a.position) > 0;
      } else {
        return a.position.compareTo(b.position) > 0;
      }
    }
    return false;
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions(List<Tile> tiles) {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> positions,
    List<int> values,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            position: whitespacePosition,
            currentValue: i,
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            position: positions[i - 1],
            currentValue: values[i - 1],
          )
    ];
  }

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles(List<Tile> tiles) {
    final whitespaceTile = tiles.singleWhere((tile) => tile.isWhitespace);
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.value == tile.currentValue) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }
}
