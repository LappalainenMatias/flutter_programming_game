import 'package:anki/constants.dart';
import 'package:anki/foundation/coordinates/coordinate_utils.dart';
import 'package:anki/foundation/coordinates/iso_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

void main() {
  test("Region point to isoCoordinate", () {
    var iso = regionPointToIsoCoordinate(const Point(1, 1));
    expect(iso.isoX, 0);
    expect(iso.isoY, 2 * regionSideWidth);

    iso = regionPointToIsoCoordinate(const Point(-1, -1));
    expect(iso.isoX, 0);
    expect(iso.isoY, -2 * regionSideWidth);
  });

  test("IsoCoordinate to region point", () {
    var point = isoCoordinateToRegionPoint(const IsoCoordinate(0, 0));
    expect(const Point(0, 0), point);

    point = isoCoordinateToRegionPoint(
        IsoCoordinate(0, (8 * regionSideWidth).toDouble()));
    expect(const Point(0, 8), point);

    point = isoCoordinateToRegionPoint(
        IsoCoordinate((8 * regionSideWidth).toDouble(), 0));
    expect(const Point(8, 0), point);

    point = isoCoordinateToRegionPoint(IsoCoordinate(
        -(8 * regionSideWidth).toDouble(), -(8 * regionSideWidth).toDouble()));
    expect(const Point(-8, -8), point);
  });
}
