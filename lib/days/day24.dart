library day24;

import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Position {
  int? hash = null;
  late int x;
  late int y;

  Position(int x, int y) {
    this.x = x;
    this.y = y;
  }

  Position neighbor(int ox, int oy) {
    return new Position(x + ox, y + oy);
  }

  @override
  int get hashCode {
    int hash = 2166136261;
    hash = (hash * 16777619) ^ x;
    hash = (hash * 16777619) ^ y;
    return hash;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is Position)) {
      return false;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return (x == other.x && y == other.y);
  }
}

class Day24 extends BaseDay {
  Day24({Key? key}) : super(day: 24, key: key);

  @override
  _Day24 createState() => _Day24();
}

class _Day24 extends BaseDayState<Day24, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<String>> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    return strings;
  }

  Position moveX(Position position, String direction, int speed) {
    switch (direction) {
      case 'e':
        position.x += speed;
        break;
      case 'w':
        position.x -= speed;
        break;
    }
    return position;
  }

  Position moveY(Position position, String direction, int speed) {
    switch (direction) {
      case 'n':
        position.y -= speed;
        break;
      case 's':
        position.y += speed;
        break;
    }
    return position;
  }

  Position getTile(String directions) {
    var pos = new Position(0, 0);
    var index = 0;
    while (index < directions.length) {
      var direction = directions[index++];
      pos = moveX(pos, direction, 2);
      pos = moveY(pos, direction, 2);
      switch (direction) {
        case 's':
        case 'n':
          direction = directions[index++];
          pos = moveX(pos, direction, 1);
          break;
      }
    }

    return pos;
  }

  HashSet<Position> getBlackTiles(List<String> directions) {
    var blackTiles = new HashSet<Position>();
    for (var direction in directions) {
      var pos = getTile(direction);
      if (blackTiles.contains(pos)) {
        blackTiles.remove(pos);
      } else {
        blackTiles.add(pos);
      }
    }

    return blackTiles;
  }

  HashSet<Position> flipTiles(HashSet<Position> blackTiles) {
    var neighbors = new Map<Position, int>();

    for (var tile in blackTiles) {
      neighbors.putIfAbsent(tile, () => 0);

      neighbors.update(tile.neighbor(2, 0), (v) => v + 1, ifAbsent: () => 1);
      neighbors.update(tile.neighbor(-2, 0), (v) => v + 1, ifAbsent: () => 1);
      neighbors.update(tile.neighbor(1, 2), (v) => v + 1, ifAbsent: () => 1);
      neighbors.update(tile.neighbor(-1, 2), (v) => v + 1, ifAbsent: () => 1);
      neighbors.update(tile.neighbor(1, -2), (v) => v + 1, ifAbsent: () => 1);
      neighbors.update(tile.neighbor(-1, -2), (v) => v + 1, ifAbsent: () => 1);
    }

    // get white tiles that needs flipping
    var toFlipWhite = neighbors.entries
        .where((e) => e.value == 2 && !blackTiles.contains(e.key))
        .map((e) => e.key)
        .toList();

    // get black tiles that needs flipping
    var toFlipBlack = neighbors.entries
        .where((e) => (e.value == 0 || e.value > 2) && blackTiles.contains(e.key))
        .map((e) => e.key)
        .toList();

    // flip white tiles
    for (var white in toFlipWhite) {
      blackTiles.add(white);
    }

    // flip white tiles
    for (var black in toFlipBlack) {
      blackTiles.remove(black);
    }

    return blackTiles;
  }

  Future<int> part1(List<String> directions) async {
    var blackTiles = getBlackTiles(directions);
    return blackTiles.length;
  }

  Future<int> part2(List<String> directions) async {
    var blackTiles = getBlackTiles(directions);

    for (var days = 100; days > 0; days--) {
      blackTiles = flipTiles(blackTiles);
    }

    return blackTiles.length;
  }
}
