import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day15 extends BaseDay {
  Day15({Key? key}) : super(day: 15, key: key);

  @override
  _Day15 createState() => _Day15();
}

class _Day15 extends BaseDayState<Day15> {
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

  Future<int> part1(List<String> input) async {
    return 0;
  }

  Future<int> part2(List<String> input) async {
    return 0;
  }
}
