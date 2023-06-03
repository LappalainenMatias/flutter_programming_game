import 'dart:math';
import 'dart:ui';
import 'package:anki/map/iso_coordinate.dart';

import '../cube.dart';
import '../tile.dart';

const Color trunkTop = Color.fromARGB(255, 197, 187, 181);
const Color trunkLeft = Color.fromARGB(255, 183, 173, 167);
const Color trunkRight = Color.fromARGB(255, 173, 162, 156);
const Color lineTop = Color.fromARGB(255, 108, 105, 104);
const Color lineLeft = Color.fromARGB(255, 89, 86, 85);
const Color lineRight = Color.fromARGB(255, 91, 87, 87);
const Color foliageTop = Color.fromARGB(255, 15, 169, 52);
const Color foliageLeft = Color.fromARGB(255, 10, 152, 44);
const Color foliageRight = Color.fromARGB(255, 8, 133, 38);

/// Used for reducing symmetry
IsoCoordinate offset = const IsoCoordinate(0, 0);

/// Creates tree from cubes
///  ________
/// |________|
/// |________|
/// |________|
///    |__|
///    |__|
List birchPosAndCol(Tile tile) {
  offset = IsoCoordinate(
    Random().nextDouble() / 2,
    Random().nextDouble() / 2,
  );
  int random = Random().nextInt(100);
  if (random < 95) {
    return _birch(tile);
  } else {
    return _birchTrunk(tile);
  }
}

List _birch(Tile tile) {
  var trunk = _birchTrunk(tile);
  var foliage1 = _birchFoliageFirstLayer(tile);
  trunk[0].addAll(foliage1[0]);
  trunk[1].addAll(foliage1[1]);
  return trunk;
}

List _birchFoliageFirstLayer(Tile tile) {
  return createCube(
    tile.coordinate,
    tile.height + 2.00,
    foliageTop.value,
    foliageLeft.value,
    foliageRight.value,
    widthScale: 1.25,
    heightScale: 2.25 * (Random().nextDouble() + 0.5),
    offset: offset,
  );
}


List _birchTrunk(Tile tile) {
  return createCube(
    tile.coordinate,
    tile.height + 1.25,
    trunkTop.value,
    trunkLeft.value,
    trunkRight.value,
    widthScale: 0.25,
    heightScale: 1.75 * (Random().nextDouble() + 0.5),
    offset: offset,
  );
}