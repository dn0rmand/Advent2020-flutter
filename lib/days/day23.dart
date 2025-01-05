library day23;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class ListItem {
  late ListItem? previous;
  late ListItem? next;
  late int value;

  ListItem(int value) {
    this.value = value;
  }

  static ListItem createItem(int value, Map<int, ListItem> map) {
    if (map.containsKey(value)) {
      return map[value]!;
    }

    map[value] = ListItem(value);
    if (value > 1) {
      map[value]!.previous = createItem(value - 1, map);
    }

    return map[value]!;
  }
}

class Runner {
  static const INPUT = [3, 1, 8, 9, 4, 6, 5, 7, 2];
  static const ONE_MILLION = 1000000;

  static Tuple2<ListItem, ListItem> loadInput(int part) {
    var items = Map<int, ListItem>();

    ListItem? first;
    ListItem? last;

    for (int value in INPUT) {
      if (last == null) {
        last = first = ListItem.createItem(value, items);
      } else {
        last.next = ListItem.createItem(value, items);
        last = last.next;
      }
    }

    if (part == 2) {
      for (var i = 10; i <= ONE_MILLION; i++) {
        last!.next = ListItem.createItem(i, items);
        last = last.next;
      }
    }

    var one = items[1]!;
    one.previous = items[part == 2 ? ONE_MILLION : 9];
    last!.next = first;

    return Tuple2(first!, one);
  }

  static void run(ListItem current, int moves) {
    for (int move = 0; move < moves; move++) {
      var v1 = current.next!;
      var v2 = v1.next!;
      var v3 = v2.next!;

      var target = current.previous!;
      while (target == v1 || target == v2 || target == v3) {
        target = target.previous!;
      }

      current = current.next = v3.next!;

      v3.next = target.next;
      target.next = v1;
    }
  }

  static int execute(int part) {
    var input = loadInput(part);
    var list = input.item1;
    var one = input.item2;

    run(list, part == 1 ? 100 : 10 * ONE_MILLION);

    int result = 0;
    if (part == 1) {
      for (var o = one.next!; o.value != 1; o = o.next!) {
        result = (result * 10) + o.value;
      }
    } else {
      result = one.next!.value * one.next!.next!.value;
    }

    return result;
  }
}

Future<int> part(int part) async {
  return Runner.execute(part);
}

class Day23 extends BaseDay {
  Day23({Key? key}) : super(day: 23, key: key);

  @override
  _Day23 createState() => _Day23();
}

class _Day23 extends BaseDayState<Day23, int, int> {
  @override
  Future execute() async {
    var p1 = compute(part, 1);
    var p2 = compute(part, 2);
    part1Value = await p1;
    part2Value = await p2;

    await super.execute();
  }
}
