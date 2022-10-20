import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../models/glass_piece.dart';

class MainController {
  final tileState = Reactable<TileState>(TileState.readyToExplode);
  final maxGlassPiece = Reactable(12);
  final animationDuration = Reactable(2000);
  final animationDirection = Reactable(Alignment.bottomCenter);
  final isSlidable = Reactable(false);
  List<GlassPiece> lastPieces = [];
}

enum TileState {
  readyToExplode,
  imploding,
}
