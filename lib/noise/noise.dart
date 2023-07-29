import 'package:open_simplex_noise/open_simplex_noise.dart';
import '../camera/level_of_detail.dart';
import '../map/map_creation_rules.dart';

class NoiseCreator {
  late OpenSimplexNoise _elevationNoise1;
  late OpenSimplexNoise _elevationNoise2;
  late OpenSimplexNoise _elevationNoise3;
  late OpenSimplexNoise _moistureNoise1;
  late OpenSimplexNoise _moistureNoise2;
  late OpenSimplexNoise _moistureNoise3;
  MapCreationRules mapCreationRules;

  NoiseCreator(this.mapCreationRules, [int seed = 1]) {
    _elevationNoise1 = OpenSimplexNoise(seed + 1);
    _elevationNoise2 = OpenSimplexNoise(seed + 2);
    _elevationNoise3 = OpenSimplexNoise(seed + 3);
    _moistureNoise1 = OpenSimplexNoise(seed + 4);
    _moistureNoise2 = OpenSimplexNoise(seed + 5);
    _moistureNoise3 = OpenSimplexNoise(seed + 6);
  }

  List<List<List<double>>> createComplexNoise(
      int width, int height, int startX, int startY, LevelOfDetail levelOfDetail) {
    List<List<double>> elevationMap = _fixedSizeList(width, height);
    List<List<double>> moistureMap = _fixedSizeList(width, height);
    int tileSize = levelOfDetail.tileMinSize;
    for (int x = 0; x < width; x += tileSize) {
      for (int y = 0; y < height; y += tileSize) {
        var i = (startX + x).toDouble();
        var j = (startY + y).toDouble();
        /// Increasing frequency adds details to the noise.
        double elevation = _elevationNoise1.eval2D(i * 0.001, j * 0.001) +
            0.1 * _elevationNoise2.eval2D(i * 0.01, j * 0.01) +
            0.01 * _elevationNoise3.eval2D(i * 0.1, j * 0.1);
        double threshold = 0.2; // choose a suitable threshold
        elevation = elevation > threshold ? elevation * 1.5 : elevation;
        double moisture = _moistureNoise1.eval2D(i * 0.006, j * 0.006) +
            0.5 * _moistureNoise2.eval2D(i * 0.016, j * 0.016) +
            0.25 * _moistureNoise3.eval2D(i * 0.048, j * 0.048);
        for (int dx = 0; dx < tileSize; dx++) {
          for (int dy = 0; dy < tileSize; dy++) {
            if (x + dx < width && y + dy < height) {
              elevationMap[x + dx][y + dy] = ((elevation + mapCreationRules.amountOfWater()) *
                  mapCreationRules.elevationAmplitude())
                  .roundToDouble();
              moistureMap[x + dx][y + dy] = moisture;
            }
          }
        }
      }
    }
    return [elevationMap, moistureMap];
  }

  List<List<List<double>>> createSimpleNoise(
      int width, int height, int startX, int startY, LevelOfDetail levelOfDetail) {
    List<List<double>> elevationMap = _fixedSizeList(width, height);
    List<List<double>> moistureMap = _fixedSizeList(width, height);
    int tileSize = levelOfDetail.tileMinSize;
    for (int x = 0; x < width; x += tileSize) {
      for (int y = 0; y < height; y += tileSize) {
        var i = (startX + x).toDouble();
        var j = (startY + y).toDouble();
        /// Increasing frequency adds details to the noise.
        double elevation = _elevationNoise1.eval2D(i * 0.01, j * 0.01);
        double moisture = _moistureNoise1.eval2D(i * 0.06, j * 0.06);
        for (int dx = 0; dx < tileSize; dx++) {
          for (int dy = 0; dy < tileSize; dy++) {
            if (x + dx < width && y + dy < height) {
              elevationMap[x + dx][y + dy] = ((elevation + mapCreationRules.amountOfWater()) *
                  mapCreationRules.elevationAmplitude())
                  .roundToDouble();
              moistureMap[x + dx][y + dy] = moisture;
            }
          }
        }
      }
    }
    return [elevationMap, moistureMap];
  }

  List<List<double>> _fixedSizeList(int width, int height) {
    List<List<double>> map = List.generate(
      width,
      (i) => List.generate(height, (i) => 0, growable: false),
      growable: false,
    );
    return map;
  }
}