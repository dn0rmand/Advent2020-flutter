import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day10 extends BaseDay {
  Day10({Key? key}) : super(day: 10, key: key);

  @override
  _Day10 createState() => _Day10();
}

class _Day10 extends BaseDayState<Day10> {
  final memoize = new Map<int, int>();

  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<int>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var adapters = strings.map((s) => int.parse(s)).toList();
    adapters.sort((a, b) => a - b);
    return adapters;
  }

  Future<int> part1(List<int> adapters) async {
    var ones = 0;
    var threes = 1;

    var current = 0;
    for (var i = 0; i < adapters.length; i++) {
      var jolt = adapters[i];
      var diff = jolt - current;
      if (diff == 1) {
        ones++;
      } else if (diff == 3) {
        threes++;
      }
      current = jolt;
    }
    return ones * threes;
  }

  int ways(List<int> adapters, int current, int index) {
    if (index >= adapters.length) {
      return 1;
    }
    var key = (current * adapters.length) + index;
    if (memoize.containsKey(key)) {
      return memoize[key]!;
    }
    var total = 0;
    for (var i = index; i < adapters.length; i++) {
      var d = adapters[i] - current;
      if (d < 0) {
        throw new Exception("That's not possible");
      }
      if (d > 3) {
        break;
      } else {
        total += ways(adapters, adapters[i], i + 1);
      }
    }
    memoize[key] = total;
    return total;
  }

  Future<int> part2(List<int> adapters) async {
    return ways(adapters, 0, 0);
  }
}
