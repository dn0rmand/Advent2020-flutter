import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day6 extends BaseDay {
  Day6({Key? key}) : super(day: 6, key: key);

  @override
  _Day6 createState() => _Day6();
}

class _Day6 extends BaseDayState<Day6> {
  @override
  Future execute() async {
    var groups = await loadInput();

    part1Value = await part1(groups);
    part2Value = await part2(groups);

    await super.execute();
  }

  Future<List<List<String>>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var data = List<List<String>>.empty(growable: true);
    var group = List<String>.empty(growable: true);

    for (var answers in strings) {
      if (answers.length == 0) {
        if (group.length > 0) {
          data.add(group);
          group = List<String>.empty(growable: true);
        }
      } else {
        group.add(answers);
      }
    }
    if (group.length > 0) {
      data.add(group);
    }
    return data;
  }

  Future<int> part1(List<List<String>> groups) async {
    var total = 0;
    for (var group in groups) {
      var questions = new HashSet<String>();
      for (var answers in group) {
        questions.addAll(answers.characters);
      }
      total += questions.length;
    }
    return total;
  }

  Future<int> part2(List<List<String>> groups) async {
    var total = 0;
    for (var group in groups) {
      var people = group.length;
      var questions = new Map<String, int>();
      for (var answers in group) {
        for (var question in answers.characters) {
          questions.update(question, (v) => v + 1, ifAbsent: () => 1);
        }
      }
      questions.removeWhere((k, v) => v != people);
      total += questions.length;
    }
    return total;
  }
}
