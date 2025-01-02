library day25;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day25 extends BaseDay {
  Day25({Key? key}) : super(day: 25, key: key);

  @override
  _Day25 createState() => _Day25();
}

class _Day25 extends BaseDayState<Day25> {
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
