library day15;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day15 extends BaseDay {
  Day15({Key? key}) : super(day: 15, key: key);

  @override
  _Day15 createState() => _Day15();
}

class _Day15 extends BaseDayState<Day15, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<int>> loadInput() async {
    var line = (await Helper.loadData(widget.day)).first;

    return line.split(',').map((s) => int.parse(s)).toList();
    // return [3, 1, 2];
  }

  int emulate(List<int> input, int turns) {
    var turn = input.length;
    var indexes = List<int>.filled(turns + 2, 0);

    for (var i = 0; i < input.length; i++) {
      var v = input[i];
      indexes[v] = i + 1;
    }

    var lastSpoken = 0;
    while (turn < turns - 1) {
      ++turn;
      if (indexes[lastSpoken] > 0) {
        var i = turn - indexes[lastSpoken];
        indexes[lastSpoken] = turn;
        lastSpoken = i;
      } else {
        indexes[lastSpoken] = turn;
        lastSpoken = 0;
      }
    }
    return lastSpoken;
  }

  Future<int> part1(List<int> input) async {
    return emulate(input, 2020);
  }

  Future<int> part2(List<int> input) async {
    return emulate(input, 30000000);
  }
}
