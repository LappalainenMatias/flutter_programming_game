import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'game.dart';
import 'game_loop.dart';

class GameMapPainter extends CustomPainter {
  final GameLoop gameLoop;
  final Game game;
  final ui.FragmentShader _waterShader;
  final _landPaint = Paint();

  /// We start with 10 because there is visual effect if you start with 0
  double _timePassed = 10;
  ui.Image textureImage;

  GameMapPainter(this._waterShader, this.gameLoop, this.game, this.textureImage)
      : super(repaint: gameLoop);

  @override
  void paint(Canvas canvas, Size size) {
    _timePassed += gameLoop.dt;
    _waterShader.setFloat(0, _timePassed);
    var waterPaint = Paint()..color = const Color(0xF21468D7);
    waterPaint.shader = _waterShader;
    _transformations(canvas, size);

    var atlasData = game.getDrawingData();

    /// Draw under water things
    for (var data in atlasData.underWater) {
      canvas.drawRawAtlas(
        textureImage,
        data.$1,
        data.$2,
        null,
        null,
        data.$3,
        _landPaint,
      );
    }

   /// Draw water plane
   canvas.drawRect(
     Rect.fromPoints(
       Offset(game.viewTopLeft.isoX, game.viewTopLeft.isoY),
       Offset(game.viewBottomRight.isoX, game.viewBottomRight.isoY),
     ),
     waterPaint,
   );

    /// Draw above water things
    for (var data in atlasData.aboveWater) {
      canvas.drawRawAtlas(
        textureImage,
        data.$1,
        data.$2,
        null,
        null,
        data.$3,
        _landPaint,
      );
    }
  }

  void _transformations(Canvas canvas, Size size) {
    double scale =
        min(size.width / game.viewWidth, size.height / game.viewHeight);
    canvas.scale(scale, scale);
    canvas.translate(
      -game.viewCenter.isoX.toDouble() + size.width / scale / 2,
      -game.viewCenter.isoY.toDouble() + size.height / scale / 2,
    );
  }

  /// Used for debuging. Shows the coordinates where the visible region hangler
  /// searched for regions.
  //void _showSearchedRegionCoordinates(Canvas canvas) {
  //  List<IsoCoordinate> points = game.getSprilalOfSearchedRegions();
  //  double width = game.viewWidth / 150;
  //  for (var p in points) {
  //    canvas.drawCircle(
  //      Offset(p.isoX, p.isoY),
  //      width,
  //      Paint()..color = const Color(0xFFBD3838),
  //    );
  //  }
  //}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
