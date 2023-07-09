import 'package:anki/map/map.dart';
import 'package:anki/map/region/region_manager.dart';
import 'package:anki/utils/iso_coordinate.dart';
import 'package:test/test.dart';

void main() {
  test("Get vertices in region manager which uses js worker", () async {
    RegionManager regionManager = RegionManager();
    MapDTO mapDTO = regionManager.getVertices(
        const IsoCoordinate.fromIso(-100, 100), const IsoCoordinate.fromIso(100, -100));
    /// At some point this test will fail when concurrency is implemented
    mapDTO = regionManager.getVertices(
        const IsoCoordinate.fromIso(-100, 100), const IsoCoordinate.fromIso(100, -100));
    expect(mapDTO.verticesCount > 0, true);
    expect(mapDTO.underWater.isNotEmpty, true);
    expect(mapDTO.aboveWater.isNotEmpty, true);
  });
}