import 'package:anki/camera/level_of_detail.dart';
import 'package:anki/game_objects/game_object.dart';
import 'package:anki/map/region/region_creation/region_creator.dart';
import 'package:anki/coordinates/iso_coordinate.dart';
import 'package:test/test.dart';

void main() {
  test('Create region dto', () {
    int width = 32;
    RegionCreator regionCreator = RegionCreator();
    ({
      IsoCoordinate regionBottomCoordinate,
      List<GameObject> gameObjects
    }) regionData = regionCreator.create(const IsoCoordinate(1, 1), width,
        width, 0, 0, LevelOfDetail.zoomlevel_0);
    expect(regionData.regionBottomCoordinate, const IsoCoordinate(1, 1));
    expect(regionData.gameObjects.length >= width, isTrue);
    expect(regionData.gameObjects.length <= width * width, isTrue);
  });
}