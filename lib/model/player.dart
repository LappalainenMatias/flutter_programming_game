import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../enum/square_types.dart';
import '../enum/actions.dart' as GameAction;
import 'map.dart';

class PlayerModel extends ChangeNotifier {
  List<GameAction.Action> actions = [];
  var _visibility = 1;
  var _x = 0;
  var _y = 0;
  var movementSpeedMs = 100;
  var hearts = 3;
  var stopped = true;
  var startedDoActions = false;

  PlayerModel(this._visibility, this._x, this._y);

  void stopMovement() {
    stopped = true;
    notifyListeners();
  }

  void startMovement() {
    stopped = false;
    notifyListeners();
  }

  void doActions(MapModel map) {
    for (var action in actions) {
      if (!stopped) action.function(this, map);
    }
    Future.delayed(Duration(milliseconds: movementSpeedMs), (){
      doActions(map);
    });
  }

  void moveDown(MapModel map) {
    if (!map.squares.containsKey(Point(_x, _y + 1))) return;
    if (map.squares[Point(_x, _y + 1)]!.type != SquareType.water) {
      _y += 1;
      map.updateSquareVisibility(this);
      notifyListeners();
    }
  }

  void moveUp(MapModel map) {
    if (!map.squares.containsKey(Point(_x, _y - 1))) return;
    if (map.squares[Point(_x, _y - 1)]!.type != SquareType.water) {
      _y -= 1;
      map.updateSquareVisibility(this);
      notifyListeners();
    }
  }

  void moveLeft(MapModel map) {
    if (!map.squares.containsKey(Point(_x - 1, _y))) return;
    if (map.squares[Point(_x - 1, _y)]!.type != SquareType.water) {
      _x -= 1;
      map.updateSquareVisibility(this);
      notifyListeners();
    }
  }

  void moveRight(MapModel map) {
    if (!map.squares.containsKey(Point(_x + 1, _y))) return;
    if (map.squares[Point(_x + 1, _y)]!.type != SquareType.water) {
      _x += 1;
      map.updateSquareVisibility(this);
      notifyListeners();
    }
  }

  set visibility(value) {
    _visibility = value;
    notifyListeners();
  }

  get y => _y;

  get x => _x;

  get visibility => _visibility;
}
