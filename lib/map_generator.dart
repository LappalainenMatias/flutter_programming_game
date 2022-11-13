import 'package:anki/square.dart';
import 'enum/square_type.dart';
import 'enum/square_visibility.dart';
import 'model/map.dart';
import 'enum/item.dart';
import 'dart:math';

class MapGenerator {
  MapModel generateRandomMap(int width, int height) {
    Map<Point, Square> squares = {};
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        squares[Point(x, y)] = Square(SquareTypeExtension.getRandomType, x, y,
            SquareVisibility.unseen, []);
      }
    }
    return MapModel(width, height, squares);
  }

  MapModel realisticRandomMap(int width, int height) {
    var random = Random(4);
    Map<Point, double> noise = {};
    Map<Point, Square> squares = {};
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        noise[Point(x, y)] = random.nextDouble();
      }
    }
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        double center = noise[Point(x, y)] ?? 0;
        double up = noise[Point(x, y - 1)] ?? 0;
        double down = noise[Point(x, y + 1)] ?? 0;
        double left = noise[Point(x - 1, y)] ?? 0;
        double right = noise[Point(x + 1, y)] ?? 0;
        noise[Point(x, y)] = (center + up + down + left + right) / 5;
      }
    }
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        SquareType st =
            SquareTypeExtension.getValueBasedOnHeight(noise[Point(x, y)]!);
        squares[Point(x, y)] = Square(st, x, y, SquareVisibility.unseen,
            ItemExtension.getRandomItems(st));
      }
    }
    return MapModel(width, height, squares);
  }
}
