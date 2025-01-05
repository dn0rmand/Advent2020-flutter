library day12;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Instruction {
  String direction = '?';
  int quantity = 0;

  Instruction(String value) {
    direction = value[0];
    quantity = int.tryParse(value.substring(1))!;
  }
}

class Position {
  int x = 0;
  int y = 0;
  int dx = 1;
  int dy = 0;

  Position(int dx, int dy) {
    this.dx = dx;
    this.dy = dy;
  }

  void rotateR(int angle) {
    while (angle > 0) {
      angle -= 90;
      var tmp = dx;
      dx = -dy;
      dy = tmp;
    }
  }

  void move(Instruction instruction, bool part2) {
    switch (instruction.direction) {
      case 'F':
        x += dx * instruction.quantity;
        y += dy * instruction.quantity;
        break;
      case 'R':
        rotateR(instruction.quantity);
        break;
      case 'L':
        rotateR(360 - instruction.quantity);
        break;
      case 'N':
        if (part2) {
          dy -= instruction.quantity;
        } else {
          y -= instruction.quantity;
        }
        break;
      case 'S':
        if (part2) {
          dy += instruction.quantity;
        } else {
          y += instruction.quantity;
        }
        break;
      case 'E':
        if (part2) {
          dx += instruction.quantity;
        } else {
          x += instruction.quantity;
        }
        break;
      case 'W':
        if (part2) {
          dx -= instruction.quantity;
        } else {
          x -= instruction.quantity;
        }
        break;
    }
  }
}

class Day12 extends BaseDay {
  Day12({Key? key}) : super(day: 12, key: key);

  @override
  _Day12 createState() => _Day12();
}

class _Day12 extends BaseDayState<Day12, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<Instruction>> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    return strings.map((v) => new Instruction(v)).toList();
  }

  Future<int> part1(List<Instruction> input) async {
    var state = new Position(1, 0);
    for (var instruction in input) {
      state.move(instruction, false);
    }
    return state.x.abs() + state.y.abs();
  }

  Future<int> part2(List<Instruction> input) async {
    var state = new Position(10, -1);
    for (var instruction in input) {
      state.move(instruction, true);
    }
    return state.x.abs() + state.y.abs();
  }
}
