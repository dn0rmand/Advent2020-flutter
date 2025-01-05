library day1;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';

class Day1 extends BaseDay {
  Day1({Key? key}) : super(day: 1, key: key);

  @override
  _Day1 createState() => _Day1();
}

class _Day1 extends BaseDayState<Day1, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<Tuple2<List<int>, Map<int, int>>> loadInput() async {
    var strings = await Helper.loadData(1);
    var data = List<int>.from(strings.map((e) => int.parse(e)));

    data.sort((a, b) => a - b);

    var map = Map<int, int>();
    for (var i = 0; i < data.length; i++) {
      map[data[i]] = i;
    }

    return Tuple2(data, map);
  }

  int search(List<int> entries, Map<int, int> map, int value, int count, int index) {
    for (var i = index; i < entries.length; i++) {
      var v1 = entries[i];
      if (v1 > value) break;

      var v2 = value - v1;

      if (count > 2) {
        var v3 = search(entries, map, v2, count - 1, i + 1);
        if (v3 != 0) {
          return v3 * v1;
        }
      } else if (map.containsKey(v2) && map[v2]! > i) {
        return v1 * v2;
      }
    }

    return 0;
  }

  Future<int> part1(Tuple2<List<int>, Map<int, int>> input) async {
    return search(input.item1, input.item2, 2020, 2, 0);
  }

  Future<int> part2(Tuple2<List<int>, Map<int, int>> input) async {
    return search(input.item1, input.item2, 2020, 3, 0);
  }
}
