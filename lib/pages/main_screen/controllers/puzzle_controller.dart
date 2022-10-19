import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:reactable/reactable.dart';

import '../../../helpers/locator.dart';
import '../../../helpers/puzzle_generator.dart';
import '../../../models/models.dart';
import 'main_controller.dart';
import 'score_controller.dart';
import 'tile_controller.dart';

class PuzzleController extends Disposable {
  final tiles = ReactableList<TileController>([]);
  final focusNode = FocusNode();
  int puzzleSize = 4;
  bool _isUpdatingSize = false;
  final _scoreController = locator<ScoreController>();
  bool isMoving = false;

  PuzzleController() {
    Future.delayed(const Duration(milliseconds: 500), shuffle);
  }

  @override
  FutureOr onDispose() {
    focusNode.dispose();
  }

  /// --------------------------------------------------------------------------
  /// ------------------------------PUZZLE SIZE---------------------------------
  /// --------------------------------------------------------------------------

  Future<void> updateSize(int size) async {
    if (_isUpdatingSize) return;
    _isUpdatingSize = true;
    await _updateTilesState(TileState.onEnd);
    for (var element in tiles) {
      element.onDispose();
    }
    tiles.clear();
    puzzleSize = size;
    tiles.addAll(
        PuzzleGenerator().generate(size).map((e) => TileController(tile: e)));

    await _updateTilesState(TileState.onStart);
    _isUpdatingSize = false;
  }

  Future<void> _updateTilesState(TileState state) {
    if (tiles.isEmpty) return Future.value();

    final toShow = List<TileController>.from(tiles);
    toShow
        .sort(((a, b) => a.currentValue.value.compareTo(b.currentValue.value)));
    var duration = 0;
    for (var element in toShow) {
      if (element.isWhitespace) {
        continue;
      }
      Future.delayed(Duration(milliseconds: duration), () {
        element.state(state);
      });
      duration += 100;
    }

    return Future.delayed(Duration(milliseconds: duration));
  }

  void solveIt() async {
    await _updateTilesState(TileState.onEnd);
    for (var item in tiles) {
      item.currentValue(item.value);
      item.isWhitespace = false;
    }
    tiles.sort((a, b) => a.currentValue.value.compareTo(b.currentValue.value));
    tiles.last.isWhitespace = true;
    tiles.last.state(TileState.whitespace);

    await _updateTilesState(TileState.onStart);
  }

  void shuffle() {
    final score = locator<ScoreController>();
    score.time(0);
    score.moves(0);
    updateSize(puzzleSize);
  }

  /// Get the single whitespace tile object in the puzzle.
  TileController getWhitespaceTile() =>
      tiles.singleWhere((tile) => tile.isWhitespace);

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles() {
    final whitespaceTile = getWhitespaceTile();
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.currentValue.value == tile.value) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }

  /// Determines if the puzzle is completed.
  bool isComplete() => getNumberOfCorrectTiles() == tiles.length - 1;

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(TileController tile) {
    if (isComplete()) {
      return false;
    }
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    return whitespaceTile.canSwitchWith(tile);
  }

  int updateValue(TileController controller) {
    final whitespaceTile = getWhitespaceTile();
    final oldValue = whitespaceTile.currentValue.value;
    whitespaceTile.updateTile(controller.currentValue.value);
    return oldValue;
  }

  void updateWhitespace(TileController controller) {
    final whitespaceTile = getWhitespaceTile();
    whitespaceTile.isWhitespace = false;
    controller.isWhitespace = true;
    controller.state.value = TileState.whitespace;
    _scoreController.moves.value++;
    _scoreController.rightTiles(getNumberOfCorrectTiles());
    isComplete();
  }

  ///---------------------------------------------------------------------------
  /// -------------------------Keyboard Events----------------------------------
  ///---------------------------------------------------------------------------

  void onKey(KeyEvent event) {
    if (isMoving) return;
    if (kDebugMode) print('Key: ${event.logicalKey.debugName}');
    isMoving = true;
    final whiteSpaceTile = getWhitespaceTile();
    var position = whiteSpaceTile.position;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      position = position.copyWith(y: position.y - 1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      position = position.copyWith(y: position.y + 1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      position = position.copyWith(x: position.x - 1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      position = position.copyWith(x: position.x + 1);
    } else {
      return;
    }
    if (!_validPosition(position)) return;
    final targetTile = tiles.singleWhere((tile) => tile.position == position);
    targetTile.explode.explode();
    Future.delayed(
        Duration(milliseconds: locator<MainController>().animationDuration),
        () {
      isMoving = false;
    });
  }

  bool _validPosition(Position position) =>
      position.x > 0 &&
      position.x <= puzzleSize &&
      position.y > 0 &&
      position.y <= puzzleSize;

  Alignment getDirection(TileController tile, {TileController? whitespace}) {
    whitespace ??= getWhitespaceTile();
    if (tile.position.x == whitespace.position.x) {
      return tile.position.y > whitespace.position.y
          ? Alignment.topCenter
          : Alignment.bottomCenter;
    } else if (tile.position.y == whitespace.position.y) {
      return tile.position.x > whitespace.position.x
          ? Alignment.centerLeft
          : Alignment.centerRight;
    }
    return Alignment.center;
  }
}
