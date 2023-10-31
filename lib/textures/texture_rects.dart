import 'dart:typed_data';
import '../game_objects/static/ground/tile_type.dart';

/// Contains the hard coded texture coordinate for each tile type.
/// The values are coordinates of the sprite_sheet.png file.
/// 36 vertices which create 6 triangles (2 for each visible side)
Float32List getTileTextureCoordinatesRect(TileType type) {
  switch (type) {
    case TileType.ice:
      return iceTexture;
    case TileType.grass:
      return grassTexture;
    case TileType.deathGrass:
      return deathGrassTexture;
    case TileType.rock:
      return rockTexture;
    case TileType.snow:
      return snowTexture;
    case TileType.sand:
      return sandTexture;
  }
}

const double _textureHeight = 161;

const int deathGrassIndex = 0;
final Float32List deathGrassTexture = Float32List.fromList([
  0, _textureHeight * deathGrassIndex,
  161, 161 + _textureHeight * deathGrassIndex,
]);

const int grassIndex = 1;
final Float32List grassTexture = Float32List.fromList([
  0, _textureHeight * grassIndex,
  161, 161 + _textureHeight * grassIndex,
]);

const int rockIndex = 2;
final Float32List rockTexture = Float32List.fromList([
  0, _textureHeight * rockIndex,
  161, 161 + _textureHeight * rockIndex,
]);

const int snowIndex = 3;
final Float32List snowTexture = Float32List.fromList([
  0,0 + _textureHeight * snowIndex,
  161, 161 + _textureHeight * snowIndex,
]);

const int iceIndex = 4;
final Float32List iceTexture = Float32List.fromList([
  0, _textureHeight * iceIndex,
  161, 161 + _textureHeight * iceIndex,
]);

const int sandIndex = 5;
final Float32List sandTexture = Float32List.fromList([
  0, _textureHeight * sandIndex,
  161, 161+ _textureHeight * sandIndex,
]);