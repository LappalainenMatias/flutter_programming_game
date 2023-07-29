import 'package:anki/camera/level_of_detail.dart';
import 'package:anki/map/map_creation_rules.dart';
import 'package:anki/noise/noise.dart';
import 'package:test/test.dart';

void main() {
  test("Noise range of values", () {
    NoiseCreator noise = NoiseCreator(
      FinlandCreationRules(),
      1,
    );
    var noises = noise.createComplexNoise(256, 256, 0, 0, LevelOfDetail.maximum);
    var elevation = noises[0];
    var moisture = noises[1];
    for (var column in elevation) {
      for (var val in column) {
        if (val < -30 || val > 20) {
          throw Exception("Elevation was too large or low. Value: $val");
        }
      }
    }
    for (var column in moisture) {
      for (var val in column) {
        if (val < -2.0 || val > 2.0) {
          throw Exception("Moisture was too large or low. Value: $val");
        }
      }
    }
  });
}