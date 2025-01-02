import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day17Key {
  int x = 0;
  int y = 0;
  int z = 0;
  int w = 0;

  Day17Key(int x, int y, int z, int w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }

  Iterable<Day17Key> getNeighbors(bool part2) sync* {
    var offsets = <int>[-1, 0, 1];
    for (var ox in offsets) {
      for (var oy in offsets) {
        for (var oz in offsets) {
          if (part2) {
            for (var ow in offsets) {
              if (ox != 0 || oy != 0 || oz != 0 || ow != 0) {
                yield new Day17Key(x + ox, y + oy, z + oz, w + ow);
              }
            }
          } else {
            if (ox != 0 || oy != 0 || oz != 0) {
              yield new Day17Key(x + ox, y + oy, z + oz, w);
            }
          }
        }
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (!(other is Day17Key)) {
      return false;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other.x == x && other.y == y && other.z == z && other.w == w;
  }

  @override
  int get hashCode {
    int hash = 2166136261;
    hash = (hash * 16777619) ^ x;
    hash = (hash * 16777619) ^ y;
    hash = (hash * 16777619) ^ z;
    hash = (hash * 16777619) ^ x;
    return hash;
  }
}

class Day17 extends BaseDay {
  Day17({Key? key}) : super(day: 17, key: key);

  @override
  _Day17 createState() => _Day17();
}

class _Day17 extends BaseDayState<Day17> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<HashSet<Day17Key>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var activeCubes = new HashSet<Day17Key>();

    for (var y = 0; y < strings.length; y++) {
      var line = strings[y];
      for (var x = 0; x < line.length; x++) {
        if (line[x] == '#') {
          var key = new Day17Key(x, y, 0, 0);
          activeCubes.add(key);
        }
      }
    }
    return activeCubes;
  }

  int process(HashSet<Day17Key> cubes, bool part2) {
    for (var cycle = 0; cycle < 6; cycle++) {
      var inactiveNeighborCount = new Map<Day17Key, int>();
      var activeNeighborCount = new Map<Day17Key, int>();

      for (var key in cubes) {
        for (var neighbor in key.getNeighbors(part2)) {
          if (!cubes.contains(neighbor)) {
            inactiveNeighborCount.update(neighbor, (count) => count + 1, ifAbsent: () => 1);
          } else {
            activeNeighborCount.update(neighbor, (count) => count + 1, ifAbsent: () => 1);
          }
        }
      }
      var newCubes = new HashSet<Day17Key>();

      var remainActive = activeNeighborCount.entries.where((e) => e.value == 2 || e.value == 3).map((e) => e.key);
      var becomeActive = inactiveNeighborCount.entries.where((e) => e.value == 3).map((e) => e.key);

      newCubes.addAll(remainActive);
      newCubes.addAll(becomeActive);

      cubes = newCubes;
    }
    return cubes.length;
  }

  Future<int> part1(HashSet<Day17Key> input) async {
    return process(input, false);
  }

  Future<int> part2(HashSet<Day17Key> input) async {
    return process(input, true);
  }
}
