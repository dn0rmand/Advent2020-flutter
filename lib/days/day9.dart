library day9;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day9 extends BaseDay {
  Day9({Key? key}) : super(day: 9, key: key);

  @override
  _Day9 createState() => _Day9();
}

class _Day9 extends BaseDayState<Day9, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<int>> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    var ints = strings.map((v) => int.parse(v));

    return ints.toList();
  }

  int findInvalid(List<int> values) {
    var previous25 = new Map<int, int>();

    previous25.clear();
    for (var i = 0; i < 25; i++) {
      previous25.update(values[i], (count) => count + 1, ifAbsent: () => 1);
    }

    for (var i = 25; i < values.length; i++) {
      var v = values[i];

      // Check if valid
      var valid = false;
      for (var e in previous25.entries) {
        if (e.value < 1) {
          continue;
        }
        var v1 = e.key;
        var v2 = v - v1;
        if (v2 >= 0 && v1 != v2 && previous25.containsKey(v2) && previous25[v2]! > 0) {
          valid = true;
          break;
        }
      }
      if (!valid) {
        return v;
      }

      // add to 25 list
      previous25.update(v, (count) => count + 1, ifAbsent: () => 1);
      // old to remove = values[i-25];
      previous25.update(values[i - 25], (count) => count - 1, ifAbsent: () => 0);
      previous25.removeWhere((key, value) => value == 0);
    }

    return -1;
  }

  Future<int> part1(List<int> values) async => findInvalid(values);

  Future<int> part2(List<int> values) async {
    var invalid = findInvalid(values);

    var sum = 0;
    for (var i = 0, j = 0; j < values.length; j++) {
      sum += values[j];
      while (sum > invalid) {
        sum -= values[i++];
      }
      if (sum == invalid) {
        var items = values.getRange(i, j + 1).toList();
        items.sort((a, b) => a - b);
        return items.first + items.last;
      }
    }

    return -1;
  }
}
