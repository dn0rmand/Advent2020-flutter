library day11;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day11 extends BaseDay {
  Day11({Key? key}) : super(day: 11, key: key);

  @override
  _Day11 createState() => _Day11();
}

class _Day11 extends BaseDayState<Day11> {
  int width = 0;
  int height = 0;
  List<int> map = List.empty();

  @override
  Future execute() async {
    await loadInput();

    part1Value = await part1();
    part2Value = await part2();

    await super.execute();
  }

  Future<void> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    width = strings[0].length;
    height = strings.length;
    map = List.filled(width * height, 0);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        switch (strings[y][x]) {
          case 'L':
            map[x + width * y] = 1;
            break;
          case '#':
            map[x + width * y] = 2;
            break;
        }
      }
    }
  }

  bool isOccupied(List<int> map, int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return false;
    }
    return map[x + width * y] == 2;
  }

  int adjacent(List<int> map, int index) {
    var x0 = index % width;
    var y0 = (index - x0) ~/ width;

    var total = 0;
    for (var y in [y0 - 1, y0, y0 + 1]) {
      for (var x in [x0 - 1, x0, x0 + 1]) {
        if (isOccupied(map, x, y)) {
          total++;
          if (total > 4) {
            break;
          }
        }
      }
    }
    return total;
  }

  int viewOccupied(List<int> map, int x, int y, int ox, int oy) {
    x += ox;
    y += oy;
    while (x >= 0 && y >= 0 && x < width && y < height) {
      switch (map[x + width * y]) {
        case 1:
          return 0;
        case 2:
          return 1;
      }
      x += ox;
      y += oy;
    }
    return 0;
  }

  int visible(List<int> map, int x, int y) {
    var total = 0;

    total += viewOccupied(map, x, y, -1, -1);
    total += viewOccupied(map, x, y, 0, -1);
    total += viewOccupied(map, x, y, 1, -1);
    total += viewOccupied(map, x, y, 1, 0);
    total += viewOccupied(map, x, y, 1, 1);
    total += total < 5 ? viewOccupied(map, x, y, 0, 1) : 0;
    total += total < 5 ? viewOccupied(map, x, y, -1, 1) : 0;
    total += total < 5 ? viewOccupied(map, x, y, -1, 0) : 0;

    return total;
  }

  int emulatePart1(List<int> map) {
    var changed = 1;

    while (changed > 0) {
      changed = 0;
      var next = List<int>.from(map);
      for (var i = 0; i < map.length; i++) {
        if (map[i] == 1) {
          // Not occupied
          if (adjacent(map, i) == 0) {
            next[i] = 2;
            changed++;
          }
        } else if (map[i] == 2) {
          if (adjacent(map, i) > 4) {
            next[i] = 1;
            changed++;
          }
        }
      }
      map = next;
    }
    return map.where((e) => e == 2).length;
  }

  int emulatePart2(List<int> map) {
    var changed = 1;

    while (changed > 0) {
      changed = 0;
      var next = List<int>.from(map);
      for (var i = 0; i < map.length; i++) {
        var x = i % width;
        var y = (i - x) ~/ width;
        if (map[i] == 1) {
          // Not occupied
          if (visible(map, x, y) == 0) {
            next[i] = 2;
            changed++;
          }
        } else if (map[i] == 2) {
          if (visible(map, x, y) > 4) {
            next[i] = 1;
            changed++;
          }
        }
      }
      map = next;
    }
    return map.where((e) => e == 2).length;
  }

  Future<int> part1() async {
    return emulatePart1(map);
  }

  Future<int> part2() async {
    return emulatePart2(map);
  }
}
