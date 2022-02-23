import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../helpers/puzzle_generator.dart';
import '../../../models/models.dart';
import 'score_controller.dart';
import 'tile_controller.dart';

class PuzzleController extends GetxController {
  final tiles = RxList<TileController>();
  final focusNode = FocusNode();
  int puzzleSize = 4;
  bool _isUpdatingSize = false;
  final _scoreController = Get.find<ScoreController>();
  bool isDone1 = false;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), shuffle);
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }

  /// --------------------------------------------------------------------------
  /// ------------------------------PUZZLE SIZE---------------------------------
  /// --------------------------------------------------------------------------

  Future<void> updateSize(int size) async {
    if (_isUpdatingSize) return;
    _isUpdatingSize = true;
    await _updateTilesState(TileState.onEnd);
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

  void solveIt() {
    for (var item in tiles) {
      item.currentValue(item.value);
    }
  }

  void shuffle() {
    final score = Get.find<ScoreController>();
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
    if (kDebugMode) print('Key: ${event.logicalKey.debugName}');

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
  }

  bool _validPosition(Position position) =>
      position.x > 0 &&
      position.x <= puzzleSize &&
      position.y > 0 &&
      position.y <= puzzleSize;
}
