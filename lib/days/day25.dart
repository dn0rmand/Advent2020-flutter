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

class _Day25 extends BaseDayState<Day25, int, String> {
  late int cardPublicKey;
  late int doorPublicKey;

  @override
  Future execute() async {
    await loadInput();

    part1Value = await part1();
    part2Value = await part2();

    await super.execute();
  }

  Future<void> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    cardPublicKey = int.parse(strings[0]);
    doorPublicKey = int.parse(strings[1]);
  }

  Future<int> part1() async {
    var k = 1;
    var loop = 0;
    while (true) {
      loop++;
      k = (k * 7) % 20201227;
      if (k == cardPublicKey) {
        return doorPublicKey.modPow(loop, 20201227);
      } else if (k == doorPublicKey) {
        return cardPublicKey.modPow(loop, 20201227);
      }
    }
  }

  Future<String> part2() async {
    return "Merry Christmas";
  }
}
