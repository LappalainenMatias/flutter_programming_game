import 'dart:math';
import 'package:anki/map/map_creation_rules.dart';
import 'package:anki/coordinates/iso_coordinate.dart';
import 'package:anki/optimization/visibility_checker.dart';
import '../../../camera/level_of_detail.dart';
import '../../../game_objects/create_game_object.dart';
import '../../../game_objects/game_object.dart';
import '../../../game_objects/static/ground/tile.dart';
import '../../../game_objects/static/natural_items/natural_items.dart';
import '../../../noise/noise.dart';

/// This class and the classes that it uses should NOT use dart:ui so that
/// we can create regions concurrently (dart:ui only runs in the main thread).
/// Because of this we cannot create Vertices or use dart:ui Colors.
class RegionCreator {
  final _mapCreationRules = SvalbardCreationRules();
  late final noise = NoiseCreator(_mapCreationRules);

  List<GameObject> create(int w, int h, int x, int y, LevelOfDetail lod) {
    final (elevation, moisture) =
        noise.createComplexNoise(w, h, x, y, lod.tileMinWidth);
    final tiles = _createTiles(x, y, elevation, moisture, lod.tileMinWidth)..sort();
    if (lod.runVisibilityChecker) {
      visibilityChecker(tiles);
    }
    return tiles;
  }

  List<Tile> _createTiles(
    int startX,
    int startY,
    List<List<double>> elevationNoise,
    List moistureNoise,
    int tileWidth,
  ) {
    List<Tile> tiles = [];
    for (var x = 0; x < elevationNoise.length; x++) {
      var elevationRow = elevationNoise[x];
      var moistureRow = moistureNoise[x];
      for (var y = 0; y < elevationNoise[0].length; y++) {
        double height = elevationRow[y];
        if (height <= 0) {
          final elevation = (height / tileWidth).floor() * tileWidth.toDouble();
          tiles.add(TileCreator.create(
            elevation,
            moistureRow[y],
            Point((startX + x * tileWidth).toDouble(),
                (startY + y * tileWidth).toDouble()),
            _mapCreationRules.tileRules(),
            tileWidth,
          ));
        } else {
          while (height > 0) {
            final elevation =
                (height / tileWidth).floor() * tileWidth.toDouble();
            tiles.add(TileCreator.create(
              elevation,
              moistureRow[y],
              Point((startX + x * tileWidth).toDouble(),
                  (startY + y * tileWidth).toDouble()),
              _mapCreationRules.tileRules(),
              tileWidth,
            ));
            height -= tileWidth;
          }
        }
      }
    }
    return tiles;
  }

  List<NaturalItem> _createNaturalItems(List<Tile> tiles) {
    List<NaturalItem> naturalItems = [];
    for (var tile in tiles) {
      NaturalItem? naturalItem = NaturalItemCreator.create(
        tile.type,
        tile.isoCoordinate,
        tile.elevation,
        _mapCreationRules.naturalItemProbabilities(),
      );

      if (naturalItem != null) {
        naturalItems.add(naturalItem);
      }
    }
    return naturalItems;
  }
}
