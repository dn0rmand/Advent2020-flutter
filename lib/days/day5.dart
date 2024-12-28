import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day5 extends BaseDay {
  Day5({Key? key}) : super(day: 5, key: key);

  @override
  _Day5 createState() => _Day5();
}

class _Day5 extends BaseDayState<Day5> {
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
    var maxId = 0;

    for (var pass in input) {
      var row = findRow(pass);
      var col = findCol(pass);
      var id = row * 8 + col;
      if (id > maxId) {
        maxId = id;
      }
    }
    return maxId;
  }

  Future<int> part2(List<String> input) async {
    var occupied = List<bool>.filled(128 * 8, false);
    for (var pass in input) {
      var row = findRow(pass);
      var col = findCol(pass);
      var id = row * 8 + col;
      occupied[id] = true;
    }
    for (var i = 1; i < occupied.length - 1; i++) {
      if (!occupied[i] && occupied[i - 1] && occupied[i + 1]) {
        return i;
      }
    }

    return -1;
  }

  int findRow(String input) {
    var min = 0;
    var max = 127;

    for (var i = 0; i < 7; i++) {
      var middle = (min + max + 1) ~/ 2;
      if (input[i] == 'F') {
        max = middle - 1;
      } else {
        min = middle;
      }
    }

    if (min != max) {
      throw new Exception("Something went wrong");
    }
    return min;
  }

  int findCol(String input) {
    var min = 0;
    var max = 7;

    for (var i = 0; i < 3; i++) {
      var middle = (min + max + 1) ~/ 2;
      if (input[7 + i] == 'L') {
        max = middle - 1;
      } else {
        min = middle;
      }
    }

    if (min != max) {
      throw new Exception("Something went wrong");
    }
    return min;
  }
}
