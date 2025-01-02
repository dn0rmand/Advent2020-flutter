library day2;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';

class Day2 extends BaseDay {
  Day2({Key? key}) : super(day: 2, key: key);

  @override
  _Day2 createState() => _Day2();
}

class _Day2 extends BaseDayState<Day2> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<Tuple4<String, String, int, int>>> loadInput() async {
    var strings = await Helper.loadData(2);
    var data = List<Tuple4<String, String, int, int>>.from(strings.map((e) {
      var rp = e.split(':');
      var password = rp[1].trim();
      var ll = rp[0].split(' ');
      var letter = ll[1].trim()[0];
      var mm = ll[0].split('-');
      var min = int.parse(mm[0]);
      var max = int.parse(mm[1]);
      return Tuple4(password, letter, min, max);
    }));

    return data;
  }

  Future<int> part1(List<Tuple4<String, String, int, int>> input) async {
    var isValid = (int min, int max, int count) {
      return min <= count && count <= max;
    };

    var countLetter = (String pwd, String letter) {
      int count = 0;
      for (int i = 0; i < pwd.length; i++) {
        if (pwd[i] == letter) {
          count++;
        }
      }
      return count;
    };

    var validPasswords = 0;

    for (var entry in input) {
      var password = entry.item1;
      var letter = entry.item2;
      var min = entry.item3;
      var max = entry.item4;

      var letters = countLetter(password, letter);
      if (isValid(min, max, letters)) validPasswords++;
    }
    return validPasswords;
  }

  Future<int> part2(List<Tuple4<String, String, int, int>> input) async {
    var validPasswords = 0;

    for (var entry in input) {
      var password = entry.item1;
      var letter = entry.item2;
      var min = entry.item3;
      var max = entry.item4;

      var c1 = password[min - 1];
      var c2 = password[max - 1];

      if ((c1 == letter && c2 != letter) || (c1 != letter && c2 == letter)) {
        validPasswords++;
      }
    }
    return validPasswords;
  }
}
