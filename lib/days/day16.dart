library day16;

import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Range {
  int from = 0;
  int to = 0;

  Range(String line) {
    var l = line.split('-').map((s) => int.parse(s));
    this.from = l.first;
    this.to = l.last;
  }
}

class Rule {
  String name = '';
  List<Range> ranges = List.empty(growable: true);

  Rule(String line) {
    var words = line.split(': ');
    name = words.first;
    ranges = words.last.split(' or ').map((e) => new Range(e)).toList();
  }

  bool isValid(int value) {
    var valid = ranges.any((range) => range.from <= value && value <= range.to);

    return valid;
  }
}

class Day16 extends BaseDay {
  Day16({Key? key}) : super(day: 16, key: key);

  @override
  _Day16 createState() => _Day16();
}

class _Day16 extends BaseDayState<Day16> {
  List<Rule> rules = List.empty(growable: true);
  List<int> myTicket = List.empty(growable: false);
  List<List<int>> nearByTickets = List.empty(growable: false);

  @override
  Future execute() async {
    await loadInput();

    part1Value = await part1();
    part2Value = await part2();

    await super.execute();
  }

  Future<void> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var i = 0;

    while (i < strings.length) {
      var line = strings[i++];
      if (line == '') {
        break;
      }
      var rule = new Rule(line);
      rules.add(rule);
    }

    // Parse my ticket

    if (strings[i++] != 'your ticket:') {
      throw new Exception("Syntax error");
    }

    myTicket = strings[i++].split(',').map((s) => int.parse(s)).toList(growable: false);

    if (strings[i++] != '') {
      throw new Exception("Syntax error");
    }

    // Parse nearby tickets

    if (strings[i++] != 'nearby tickets:') {
      throw new Exception("Syntax error");
    }

    nearByTickets = strings
        .getRange(i, strings.length)
        .map((t) => t.split(',').map((s) => int.parse(s)).toList(growable: false))
        .toList(growable: false);
  }

  int validateTicket(List<int> ticket) {
    var error = 0;

    for (var value in ticket) {
      var valid = rules.any((rule) => rule.isValid(value));
      if (!valid) {
        error += value;
      }
    }
    return error;
  }

  Future<int> part1() async {
    var scanningError = nearByTickets.map((ticket) => validateTicket(ticket)).reduce((sum, error) => sum + error);
    return scanningError;
  }

  Future<int> part2() async {
    var tickets = nearByTickets.where((t) => validateTicket(t) == 0).followedBy([myTicket]).toList();
    var fieldCount = myTicket.length;
    var unusedFields = List<int>.generate(fieldCount, (i) => i);
    var fields = new Map<String, int>();
    var fieldUsed = new HashSet<int>();

    var rules = this.rules;

    while (fieldUsed.length < fieldCount) {
      rules = rules.where((r) => !fields.containsKey(r.name)).toList();
      unusedFields = unusedFields.where((f) => !fieldUsed.contains(f)).toList();

      if (rules.length == 1 && unusedFields.length == 1) {
        fields[rules.first.name] = unusedFields.first;
        break;
      }

      var dead = true;

      for (var rule in rules.where((r) => !fields.containsKey(r.name))) {
        var possible = List<int>.empty(growable: true);
        for (var i = 0; i < fieldCount; i++) {
          if (fieldUsed.contains(i)) {
            continue;
          }
          if (tickets.every((t) => rule.isValid(t[i]))) {
            possible.add(i);
          }
        }
        if (possible.length == 1) {
          dead = false;
          fields[rule.name] = possible.first;
          fieldUsed.add(possible.first);
        }
      }

      if (dead) {
        return -1;
      }
    }

    var total = 1;
    for (var e in fields.entries) {
      if (e.key.startsWith('departure')) {
        total *= myTicket[e.value];
      }
    }
    return total;
  }
}
