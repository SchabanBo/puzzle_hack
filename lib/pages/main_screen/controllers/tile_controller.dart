import 'package:get/get.dart';

import '../../../models/models.dart';
import '../views/puzzle/tile/effects/explodable_piece.dart';

class TileController extends GetxController {
  final int value;
  final Position position;
  final explode = ExplodeNotifier();
  bool isWhitespace = false;
  final state = Rx<TileState>(TileState.whitespace);
  final Rx<int> currentValue;

  int newValue = 0;

  TileController({
    required Tile tile,
  })  : value = tile.value,
        position = tile.position,
        currentValue = tile.currentValue.obs {
    newValue = currentValue.value;
    if (tile.isWhitespace) {
      isWhitespace = true;
      state.value = TileState.whitespace;
    }
  }

  @override
  void onClose() {
    super.onClose();
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
