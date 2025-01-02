library day3;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day3 extends BaseDay {
  Day3({Key? key}) : super(day: 3, key: key);

  @override
  _Day3 createState() => _Day3();
}

class _Day3 extends BaseDayState<Day3> {
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

  int calculateTrees(List<String> input, int right, int down) {
    var x = 0, y = 0;
    var width = input[0].length;

    var trees = 0;
    while (y < input.length) {
      x = (x + right) % width;
      y = y + down;

      if (y < input.length && input[y][x] == '#') {
        trees++;
      }
    }

    return trees;
  }

  Future<int> part1(List<String> input) async {
    var input = await loadInput();
    var trees = calculateTrees(input, 3, 1);
    return trees;
  }

  Future<int> part2(List<String> input) async {
    var input = await loadInput();

    var trees = calculateTrees(input, 1, 1) *
        calculateTrees(input, 3, 1) *
        calculateTrees(input, 5, 1) *
        calculateTrees(input, 7, 1) *
        calculateTrees(input, 1, 2);

    return trees;
  }
}
