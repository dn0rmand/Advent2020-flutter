import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day14 extends BaseDay {
  Day14({Key? key}) : super(day: 14, key: key);

  @override
  _Day14 createState() => _Day14();
}

class Day14Context {
  int sum = 0;
  Map<int, int> memory = new Map<int, int>();
  String mask = '';

  Day14Context() {}

  void setInnerValue(int address, int value, int bit) {
    if (bit == 0) {
      if (memory.containsKey(address)) {
        sum -= memory[address]!;
      }
      sum += value;
      memory[address] = value;
    } else {
      var or = 1 << (bit - 1);

      switch (mask[36 - bit]) {
        case '1':
          setInnerValue(address | or, value, bit - 1);
          break;

        case '0':
          setInnerValue(address, value, bit - 1);
          break;

        case 'X':
          {
            var newAddress = address | or;
            setInnerValue(newAddress, value, bit - 1);
            setInnerValue(newAddress - or, value, bit - 1);
            break;
          }
      }
    }
  }

  void setValue(int address, int value) {
    setInnerValue(address, value, 36);
  }
}

class _Day14 extends BaseDayState<Day14> {
  int orMask = 0;
  int andMask = 0;

  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  parseMask(String mask) {
    orMask = 0;
    andMask = 0;
    for (var i = 0; i < mask.length; i++) {
      var c = mask[i];

      orMask *= 2;
      andMask *= 2;

      if (c == '1') {
        orMask |= 1;
      } else if (c != '0') {
        andMask |= 1;
      }
    }
  }

  Future<List<String>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    return strings;
  }

  Future<int> part1(List<String> input) async {
    var memory = new Map<int, int>();

    var total = 0;

    for (var s in input) {
      if (s.startsWith('mask')) {
        parseMask(s.substring(7));
      } else if (s.startsWith('mem[')) {
        var addresses = s.substring(4).split('] = ');
        var address = int.parse(addresses[0]);
        var value = int.parse(addresses[1]);
        value = (value & andMask) | orMask;
        if (memory.containsKey(address)) {
          total -= memory[address]!;
        }
        memory[address] = value;
        total += value;
      }
    }

    return total;
  }

  Future<int> part2(List<String> input) async {
    var context = new Day14Context();

    for (var s in input) {
      if (s.startsWith('mask')) {
        context.mask = s.substring(7);
      } else if (s.startsWith('mem[')) {
        var addresses = s.substring(4).split('] = ');
        var address = int.parse(addresses[0]);
        var value = int.parse(addresses[1]);
        context.setValue(address, value);
      }
    }

    return context.sum;
  }
}
