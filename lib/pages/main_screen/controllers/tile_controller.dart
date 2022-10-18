import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:reactable/reactable.dart';

import '../../../models/models.dart';
import '../views/puzzle/tile/effects/explodable_piece.dart';

class TileController extends Disposable {
  final int value;
  final Position position;
  final explode = ExplodeNotifier();
  bool isWhitespace = false;
  final state = Reactable<TileState>(TileState.whitespace);
  final Reactable<int> currentValue;

  int newValue = 0;

  TileController({
    required Tile tile,
  })  : value = tile.value,
        position = tile.position,
        currentValue = tile.currentValue.asReactable {
    newValue = currentValue.value;
    if (tile.isWhitespace) {
      isWhitespace = true;
      state.value = TileState.whitespace;
    }
  }

  @override
  FutureOr onDispose() {
    explode.dispose();
  }

  bool canSwitchWith(TileController other) =>
      position.x == other.position.x &&
          (position.y == other.position.y + 1 ||
              position.y == other.position.y - 1) ||
      position.y == other.position.y &&
          (position.x == other.position.x + 1 ||
              position.x == other.position.x - 1);

  void updateTile(int newValue) {
    currentValue(newValue);
    state(TileState.imploding);
  }
}

enum TileState {
  onStart,
  readyToExplode,
  imploding,
  whitespace,
  onEnd,
}
