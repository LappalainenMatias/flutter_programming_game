import 'dart:math';
import 'package:anki/map/region/game_objects/ground/tile_type.dart';
import 'package:anki/map/region/game_objects/ground/tile.dart';
import 'package:test/test.dart';

void main() {
  test("Sort tiles", () {
    SingleTile t1 = SingleTile(TileType.taiga, const Point(1, 1), 1);
    SingleTile t2 = SingleTile(TileType.taiga, const Point(0, 1), 1);
    SingleTile t3 = SingleTile(TileType.taiga, const Point(0, 0), 1);
    SingleTile t4 = SingleTile(TileType.taiga, const Point(-1, 0), 1);
    SingleTile t5 = SingleTile(TileType.taiga, const Point(-1, -1), 1);
    List<Tile> tiles = [t4, t5, t3, t1, t2];
    tiles.sort();
    expect(tiles[0], t1);
    expect(tiles[1], t2);
    expect(tiles[2], t3);
    expect(tiles[3], t4);
    expect(tiles[4], t5);
  });

  test("Sort tiles with different widths", () {
    AreaTile t1 = AreaTile(TileType.taiga, const Point(0, 0), 1, width: 3);
    SingleTile t2 = SingleTile(TileType.taiga, const Point(2, -1), 1);
    SingleTile t3 = SingleTile(TileType.taiga, const Point(3, 0), 1);
    SingleTile t4 = SingleTile(TileType.taiga, const Point(-1, 1), 1);
    AreaTile t5 = AreaTile(TileType.taiga, const Point(0, 0), 2, width: 2);
    List<Tile> tiles = [t1, t2, t3, t4, t5];
    tiles.sort();
    expect(tiles[0], t3);
    expect(tiles[1], t1);
    expect(tiles[2] == t2 || tiles[2] == t5, true);
    expect(tiles[3] == t2 || tiles[3] == t5, true);
    expect(tiles[4], t4);
  });

  test("Sort tiles with different heights", () {
    AreaTile t1 = AreaTile(TileType.taiga, const Point(0, 0), 1, width: 3);
    AreaTile t2 = AreaTile(TileType.taiga, const Point(0, 0), 2, width: 2);
    SingleTile t3 = SingleTile(TileType.taiga, const Point(0, 0), 3);
    List<Tile> tiles = [t3, t1, t2];
    tiles.sort();
    expect(tiles[0], t1);
    expect(tiles[1], t2);
    expect(tiles[2], t3);
  });

  test("Sort tiles with different heights", () {
    AreaTile t1 = AreaTile(TileType.taiga, const Point(0, 0), 1, width: 3);
    SingleTile t2 = SingleTile(TileType.taiga, const Point(0, 0), 2);
    SingleTile t3 = SingleTile(TileType.taiga, const Point(0, 0), 5);
    List<Tile> tiles = [t3, t1, t2];
    tiles.sort();
    expect(tiles[0], t1);
    expect(tiles[1] == t2 || tiles[1] == t3, true);
    expect(tiles[2] == t2 || tiles[2] == t3, true);
  });
}