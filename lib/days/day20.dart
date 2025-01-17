library day20;

import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';

abstract class Image {
  int get width;
  int get height;

  bool getPixel(int x, int y);

  bool get(int state, int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) {
      return false;
    }

    bool flipped = state >= 4;
    int rotation = state % 4;

    if (flipped) {
      x = width - 1 - x;
    }

    switch (rotation) {
      case 0:
        return getPixel(x, y);
      case 1:
        return getPixel(height - 1 - y, x);
      case 2:
        return getPixel(width - 1 - x, height - 1 - y);
      case 3:
        return getPixel(y, width - 1 - x);
      default:
        throw new Exception("Not Possible");
    }
  }
}

class ImageState {
  late Image image;
  late int state;

  ImageState(Image image, int state) {
    this.image = image;
    this.state = state;
  }

  bool get(int x, int y) {
    return image.get(state, x, y);
  }

  int get width => (state % 2) == 1 ? image.height : image.width;
  int get height => (state % 2) == 1 ? image.width : image.height;
}

class Tile extends Image {
  static var powers = <int>[512, 256, 128, 64, 32, 16, 8, 4, 2, 1];

  int id = 0;
  List<int> data = List.filled(10, 0);
  List<Tile> possibleMatch = List.empty(growable: true);

  @override
  int get width => 10;

  @override
  int get height => 10;

  @override
  bool getPixel(int x, int y) {
    return (data[y] & powers[x]) != 0;
  }

  static Tile parse(List<String> strings, int index, Iterable<Tile> others) {
    var tile = new Tile();

    if (index + 11 >= strings.length) {
      throw new Exception("EOF");
    }
    if (!strings[index].startsWith('Tile ')) {
      throw new Exception("Prefix not found");
    }

    tile.id = int.parse(strings[index].substring(5, 9).trim());
    for (var i = 0; i < 10; i++) {
      var s = strings[index + 1 + i];
      var v = 1024;
      for (var j = 0; j < 10; j++) {
        v = v ~/ 2;
        if (s[j] == '#') {
          tile.data[i] |= powers[j];
        }
      }
    }

    for (var other in others) {
      if (tile.isMatch(other)) {
        other.possibleMatch.add(tile);
        tile.possibleMatch.add(other);
      }
    }

    return tile;
  }

  bool isMatch(Tile other) {
    for (var state1 = 0; state1 < 4; state1++) {
      for (var state2 = 0; state2 < 8; state2++) {
        var isMatch = true;
        for (var y = 0; y < 10; y++) {
          if (!this.get(state1, 0, y) == other.get(state2, 0, y)) {
            isMatch = false;
            break;
          }
        }
        if (isMatch) {
          return true;
        }
      }
    }
    return false;
  }
}

class TileState extends ImageState {
  late int key;
  late int id;
  late Tile tile;

  TileState(Tile tile, int state) : super(tile, state) {
    this.tile = tile;
    id = tile.id;
    key = tile.id * 10 + state;
  }
}

class TiledImage {
  int? hash = null;
  late int x;
  late int y;
  late List<TileState> tiles;
  late HashSet<int> used;

  TiledImage() {
    x = 0;
    y = 0;
    tiles = List.empty(growable: true);
    used = new HashSet();
  }

  static TiledImage from(TiledImage from) {
    var image = new TiledImage();

    image.x = from.x;
    image.y = from.y;
    image.tiles = List.from(from.tiles);
    image.used = HashSet.from(from.used);

    return image;
  }

  @override
  int get hashCode {
    if (hash == null) {
      hash = 2166136261;
      if (y > 0) {
        for (var xx = this.x; xx < 12; xx++) {
          var t = tiles[xx + (y - 1) * 12];
          hash = (hash! * 16777619) ^ t.hashCode;
        }
      }
      if (x > 0) {
        for (var xx = 0; xx < x; xx++) {
          var t = tiles[xx + y * 12];
          hash = (hash! * 16777619) ^ t.hashCode;
        }
      }
    }
    return hash!;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is TiledImage)) {
      return false;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (x != other.x || y != other.y) {
      return false;
    }
    for (var id in used) {
      if (!other.used.contains(id)) {
        return false;
      }
    }
    if (y > 0) {
      for (var xx = this.x; xx < 12; xx++) {
        var idx = xx + (y - 1) * 12;
        var t1 = tiles[idx];
        var t2 = other.tiles[idx];
        if (t1.key != t2.key) {
          return false;
        }
      }
    }
    if (x > 0) {
      for (var xx = 0; xx < x; xx++) {
        var idx = xx + y * 12;
        var t1 = tiles[idx];
        var t2 = other.tiles[idx];
        if (t1.key != t2.key) {
          return false;
        }
      }
    }

    return true;
  }

  List<Tile> getSides() {
    List<Tile>? left = null;
    List<Tile>? right = null;

    if (x > 0) {
      var t = tiles[y * 12 + x - 1];
      left = t.tile.possibleMatch;
    }
    if (y > 0) {
      var t = tiles[(y - 1) * 12 + x];
      right = t.tile.possibleMatch;
    }
    if (left != null && right != null) {
      var tiles = left.where((t) => right!.contains(t)).toList();
      return tiles;
    } else if (left != null) {
      return left;
    } else {
      return right!;
    }
  }

  TiledImage? addTile(TileState tile) {
    if (used.contains(tile.id)) {
      return null;
    }

    if (x > 0) {
      // need to match the one on the left
      var left = tiles[y * 12 + x - 1]; // should actually be the last one
      for (var yy = 0; yy < 10; yy++) {
        var a = left.get(9, yy);
        var b = tile.get(0, yy);
        if (a != b) {
          return null;
        }
      }
    }

    if (y > 0) {
      // need to match the one above
      var above = tiles[(y - 1) * 12 + x];
      for (var xx = 0; xx < 10; xx++) {
        var a = above.get(xx, 9);
        var b = tile.get(xx, 0);
        if (a != b) {
          return null;
        }
      }
    }

    var newState = TiledImage.from(this);

    newState.tiles.add(tile);
    newState.used.add(tile.id);
    newState.x++;
    if (newState.x == 12) {
      newState.x = 0;
      newState.y++;
    }
    return newState;
  }
}

class SeaMonster {
  //                   #
  // #    ##    ##    ###
  //  #  #  #  #  #  #

  int get size => 15;

  Iterable<Tuple2<int, int>> getPoints() sync* {
    yield Tuple2(0, 1);
    yield Tuple2(1, 2);
    yield Tuple2(4, 2);
    yield Tuple2(5, 1);
    yield Tuple2(6, 1);
    yield Tuple2(7, 2);
    yield Tuple2(10, 2);
    yield Tuple2(11, 1);
    yield Tuple2(12, 1);
    yield Tuple2(13, 2);
    yield Tuple2(16, 2);
    yield Tuple2(17, 1);
    yield Tuple2(18, 0);
    yield Tuple2(18, 1);
    yield Tuple2(19, 1);
  }

  int get width => 20;
  int get height => 3;

  int count(ImageState picture) {
    var c = 0;
    for (var y = 0; y < picture.height - height; y++) {
      for (var x = 0; x < picture.width - width; x++) {
        var found = true;
        for (var t in getPoints()) {
          if (!picture.get(x + t.item1, y + t.item2)) {
            found = false;
            break;
          }
        }
        if (found) {
          c++;
        }
      }
    }
    return c;
  }

  int search(Picture picture) {
    var max = 0;
    for (var state = 0; state < 8; state++) {
      var c = count(new ImageState(picture, state));
      if (c > max) {
        max = c;
      }
    }
    return max;
  }
}

class Picture extends Image {
  List<List<bool>> data = List.empty(growable: true);

  int roughness = 0;
  int _width = 0;
  int _height = 0;

  @override
  int get width => _width;

  @override
  int get height => _height;

  @override
  bool getPixel(int x, int y) => data[y][x];

  void setPixel(int x, int y, bool value) {
    if (value) {
      roughness++;
    }
    while (data.length <= y) {
      data.add(List<bool>.empty(growable: true));
    }

    var l = data[y];
    while (l.length <= x) {
      l.add(false);
    }
    l[x] = value;

    if (_width <= x) {
      _width = x + 1;
    }
    if (_height <= y) {
      _height = y + 1;
    }
  }
}

class Day20 extends BaseDay {
  Day20({Key? key}) : super(day: 20, key: key);

  @override
  _Day20 createState() => _Day20();
}

class _Day20 extends BaseDayState<Day20, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<Map<int, Tile>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var tiles = new Map<int, Tile>();

    for (var i = 0; i < strings.length; i += 12) {
      var tile = Tile.parse(strings, i, tiles.values);
      tiles[tile.id] = tile;
    }
    return tiles;
  }

  Future<int> part1(Map<int, Tile> tiles) async {
    var corners = tiles.values.where((t) => t.possibleMatch.length == 2);

    if (corners.length != 4) {
      throw new Exception("Not the right number of corners");
    }

    var result = corners.fold<int>(1, (a, t) => a * t.id);
    return result;
  }

  Picture generatePicture(Map<int, Tile> tiles) {
    var corners = tiles.values.where((t) => t.possibleMatch.length == 2);

    var images = new HashSet<TiledImage>();
    var newImages = new HashSet<TiledImage>();
    var found = new HashSet<TiledImage>();

    for (var corner in corners) {
      for (var state = 0; state < 4; state++) {
        var image = new TiledImage().addTile(new TileState(corner, state));
        images.add(image!);
      }
    }

    while (images.length != 0) {
      newImages.clear();
      for (var image in images) {
        if (image.used.length == tiles.length) {
          found.add(image);
        }

        var sides = image.getSides();

        for (var tile in sides) {
          if (image.used.contains(tile.id)) {
            continue;
          }
          for (var state = 0; state < 8; state++) {
            var ts = new TileState(tile, state);
            var newImage = image.addTile(ts);
            if (newImage != null) {
              newImages.add(newImage);
            }
          }
        }
      }
      var x = newImages;
      newImages = images;
      images = x;
    }

    if (found.length != 4) {
      throw new Exception('Expected 4 images ... 8 states');
    }

    var finalImage = found.first;
    var picture = new Picture();

    var yPicture = 0;

    for (var yImage = 0; yImage < 12; yImage++) {
      var xPicture = 0;

      for (var xImage = 0; xImage < 12; xImage++) {
        var tile = finalImage.tiles[yImage * 12 + xImage];

        for (var yTile = 1; yTile < 9; yTile++) {
          for (var xTile = 1; xTile < 9; xTile++) {
            var pixel = tile.get(xTile, yTile);
            picture.setPixel(xPicture + xTile - 1, yPicture + yTile - 1, pixel);
          }
        }

        xPicture += 8;
      }

      yPicture += 8;
    }

    return picture;
  }

  Future<int> part2(Map<int, Tile> tiles) async {
    var picture = generatePicture(tiles);
    var seaMonster = new SeaMonster();

    var count = seaMonster.search(picture);

    return picture.roughness - count * seaMonster.size;
  }
}
