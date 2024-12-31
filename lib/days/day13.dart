import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day13 extends BaseDay {
  Day13({Key? key}) : super(day: 13, key: key);

  @override
  _Day13 createState() => _Day13();
}

class _Day13 extends BaseDayState<Day13> {
  int earliestDepartTime = 0;
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<int>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    earliestDepartTime = int.parse(strings[0]);
    var ids = strings[1].split(',').map((s) => s == 'x' ? -1 : int.parse(s)).toList();
    return ids;
  }

  Future<int> part1(List<int> input) async {
    var min = earliestDepartTime;
    var id = -1;

    for (var i in input.where((i) => i > 0)) {
      var d = i - (earliestDepartTime % i);
      if (d < min) {
        id = i;
        min = d;
      }
    }
    return id * min;
  }

  Future<int> part2(List<int> input) async {
    var answer = 0;
    var offset = 1;

    for (var index = 0; index < input.length; index++) {
      var id = input[index];
      if (id <= 0) {
        continue;
      }
      var target = (id - (index % id)) % id;

      while ((answer % id) != target) {
        answer += offset;
      }
      offset = Helper.lcm(offset, id);
    }

    return answer;
  }
}
