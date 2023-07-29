import 'dart:convert';
import 'package:anki/game_objects/game_objects_to_vertices.dart';
import 'package:anki/game_objects/static/ground/tile_type.dart';
import 'package:anki/utils/iso_coordinate.dart';
import 'dart:math';
import '../../../collision/collision_box.dart';
import '../../../../../utils/vertice_dto.dart';
import '../../game_object.dart';

abstract class Tile extends GameObject {
  @override
  VerticeDTO getVertices();

  @override
  double nearness() {
    Point point = getIsoCoordinate().toPoint();
    return -1 * (point.x + point.y + getWidth()).toDouble();
  }

  /// todo the elevation should be 0 and the tiles have a height
  double getElevation();

  IsoCoordinate getIsoCoordinate();

  TileType getType();

  double getWidth();

  @override
  bool isUnderWater() {
    return getElevation() < 0;
  }

  @override
  bool isDynamic() {
    return false;
  }

  @override
  CollisionBox getCollisionBox() {
    /// todo we should not be constantly creating new collision boxes
    return CollisionBox(getIsoCoordinate(), getWidth(), getWidth());
  }
}

/// This is used for optimization. One large tile is faster to render than many small tiles.
class AreaTile extends Tile {
  final TileType type;
  IsoCoordinate isoCoordinate;
  double elevation;
  double width;
  VerticeDTO vertices = VerticeDTO.empty();

  AreaTile(this.type, this.isoCoordinate, this.elevation, {this.width = 1}) {
    vertices = AreaTileToVertices.toVertices(this);
  }

  @override
  getVertices() {
    if (vertices.isEmpty()) {
      vertices = AreaTileToVertices.toVertices(this);
    }
    return vertices;
  }

  @override
  getElevation() {
    return elevation;
  }

  @override
  getIsoCoordinate() {
    return isoCoordinate;
  }

  @override
  getType() {
    return type;
  }

  @override
  getWidth() {
    return width;
  }

  factory AreaTile.fromString(String json) {
    final data = jsonDecode(json);
    List<String> point = data['isoCoordinate']!.split(',');
    return AreaTile(
      TileType.values.byName(data['type']),
      IsoCoordinate.fromIso(
        double.parse(point[0]),
        double.parse(point[1]),
      ),
      data['elevation'] as double,
      width: data['width'] as double,
    );
  }

  @override
  String encode() {
    return jsonEncode({
      'gameObjectType': 'AreaTile',
      'type': type.name,
      'isoCoordinate': '${isoCoordinate.isoX},${isoCoordinate.isoY}',
      'elevation': elevation,
      'width': width,
    });
  }
}

class SingleTile extends Tile {
  final TileType type;
  IsoCoordinate isoCoordinate;
  double elevation;
  VerticeDTO vertices = VerticeDTO.empty();

  SingleTile(this.type, this.isoCoordinate, this.elevation) {
    vertices = SingleTileToVertices.toVertices(this);
  }

  @override
  getVertices() {
    if (vertices.isEmpty()) {
      vertices = SingleTileToVertices.toVertices(this);
    }
    return vertices;
  }

  @override
  getElevation() {
    return elevation;
  }

  @override
  getIsoCoordinate() {
    return isoCoordinate;
  }

  @override
  getType() {
    return type;
  }

  @override
  getWidth() {
    return 1;
  }

  AreaTile toAreaTile(double width) {
    return AreaTile(type, isoCoordinate, elevation, width: width);
  }

  factory SingleTile.fromString(String json) {
    final data = jsonDecode(json);
    List<String> point = data['isoCoordinate']!.split(',');
    return SingleTile(
      TileType.values.byName(data['type']),
      IsoCoordinate.fromIso(
        double.parse(point[0]),
        double.parse(point[1]),
      ),
      data['elevation'] as double,
    );
  }

  @override
  String encode() {
    return jsonEncode({
      'gameObjectType': 'SingleTile',
      'type': type.name,
      'isoCoordinate': '${isoCoordinate.isoX},${isoCoordinate.isoY}',
      'elevation': elevation,
    });
  }
}