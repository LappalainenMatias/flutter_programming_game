import 'dart:math';

import 'package:anki/map/map.dart';

import '../character/character.dart';
import '../map/map_helper.dart';
import '../map/square.dart';

class PlayerMover {
  double movementSpeedMS = 1000;
  DateTime lastMovement = DateTime.now();
  MapModel map;

  PlayerMover(this.map);

  void _move(int newX, int newY, Character character) {
    Square square = map.getSquare(newX, newY);
    if (square.type.isVisitable) {
      character.setCoordinate(Point(newX, newY));
    }
  }

  /// Moves the character in the direction indicated by the origin (0, 0) and (x, y)
  /// (0, 1) = up, (-1, 0) = left
  void joyStickMovement(
      double joyStickX, double joyStickY, Character character) {
    double distance = euclideanDistance(0, 0, joyStickX, joyStickY);
    if (distance > 1.1) throw Exception("Too large distance: $distance");
    movementSpeedMS = 500 - (400 * distance).abs();
    if (movementSpeedMS >
        DateTime.now().difference(lastMovement).inMilliseconds) {
      return;
    }
    if (movementSpeedMS < 100) movementSpeedMS = 100;
    lastMovement = DateTime.now();
    double angle = (atan2(joyStickX, joyStickY) * (180 / pi) + 360) % 360;
    int x = character.getCoordinate().x;
    int y = character.getCoordinate().y;
    if (angle > 337.5 || angle < 22.5) {
      _move(x, y - 1, character); // Up
    } else if (angle > 22.5 && angle < 67.5) {
      _move(x + 1, y - 1, character); // Up right
    } else if (angle > 67.5 && angle < 112.5) {
      _move(x + 1, y, character); // Right
    } else if (angle > 112.5 && angle < 157.5) {
      _move(x + 1, y + 1, character); // Down right
    } else if (angle > 157.5 && angle < 202.5) {
      _move(x, y + 1, character); // Down
    } else if (angle > 202.5 && angle < 247.5) {
      _move(x - 1, y + 1, character); // Down left
    } else if (angle > 247.5 && angle < 292.5) {
      _move(x - 1, y, character); // Left
    } else if (angle > 292.5 && angle < 337.5) {
      _move(x - 1, y - 1, character); // Up left
    }
  }
}