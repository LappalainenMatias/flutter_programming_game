import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'game.dart';
import 'online/online.dart';

class GameLoop extends ChangeNotifier {
  late final Ticker _ticker;
  late final Game game;
  late final Online online;
  double dt = 0.0;
  Duration _previous = Duration.zero;
  int missedFrames = 0;

  GameLoop(TickerProvider vsync, this.game, this.online) {
    _ticker = vsync.createTicker(_onTick)..start();
  }

  void _onTick(Duration timestamp) {
    final durationDelta = timestamp - _previous;
    dt = durationDelta.inMilliseconds / Duration.millisecondsPerSecond;
    if (dt > 0.017) {
      missedFrames++;
    }
    _previous = timestamp;
    update(dt);
    notifyListeners(); // This causes map to render gameobjects
  }

  void update(var dt) {
    if (game.getGameState() == GameState.gameOver) {
      game.reset();
    }
    game.updateMap();
    game.updateDynamicGameObjects(dt);
    game.movePlayer(dt);
    game.updateOnlineGameObjects(online.getOpponents());
    online.updatePlayer(game.getOurPlayer());
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
