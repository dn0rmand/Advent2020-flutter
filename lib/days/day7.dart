library day7;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Bag {
  String color = "";
  Map<Bag, int> content = new Map();

  Bag(String color) {
    this.color = color;
  }

  void Add(Bag bag, int count) {
    content[bag] = count;
  }

  bool Contains(Bag bag) {
    if (content.containsKey(bag)) {
      return true;
    }

    for (var subBag in content.keys) {
      if (subBag.Contains(bag)) {
        return true;
      }
    }

    return false;
  }

  int get count {
    int total = 0;
    for (var x in content.entries) {
      total += x.value * (1 + x.key.count);
    }
    return total;
  }

  @override
  bool operator ==(Object other) => other is Bag && this.color == other.color;

  @override
  int get hashCode => this.color.hashCode;
}

class Day7 extends BaseDay {
  Day7({Key? key}) : super(day: 7, key: key);

  @override
  _Day7 createState() => _Day7();
}

class _Day7 extends BaseDayState<Day7, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<Bag>> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var bags = new Map<String, Bag>();
    for (var line in strings) {
      var info = line.split(' bags contain ');
      var bag = new Bag(info[0]);
      if (bags.containsKey(bag.color)) {
        bag = bags[bag.color]!; // get right instance
      } else {
        bags[bag.color] = bag;
      }
      var list = info[1].split(', ');
      for (var b in list) {
        info = b.split(' ');
        if (info.length <= 3) {
          continue;
        }
        var count = int.parse(info[0]);
        var color = info[1] + ' ' + info[2];
        if (!bags.containsKey(color)) {
          bags[color] = new Bag(color);
        }
        var innerBag = bags[color]!;
        bag.Add(innerBag, count);
      }
    }
    return bags.values.toList();
  }

  Future<int> part1(List<Bag> input) async {
    var total = 0;

    var shinyGold = input.firstWhere((b) => b.color == 'shiny gold');

    for (var bag in input) {
      if (bag.Contains(shinyGold)) {
        total++;
      }
    }
    return total;
  }

  Future<int> part2(List<Bag> input) async {
    var shinyGold = input.firstWhere((b) => b.color == 'shiny gold');

    return shinyGold.count;
  }
}
