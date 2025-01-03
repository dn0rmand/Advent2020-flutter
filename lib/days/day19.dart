library day19;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

abstract class Rule {
  late final int id;

  Rule(int id) {
    this.id = id;
  }

  Iterable<int> match(String message, int index);
}

class SimpleRule extends Rule {
  late final String value;

  SimpleRule(int id, String value) : super(id) {
    this.value = value;
  }

  @override
  Iterable<int> match(String message, int index) sync* {
    if (index >= 0 && index < message.length && message[index] == value) {
      yield 1;
    }
  }
}

class ComplexRule extends Rule {
  List<int> _ruleIds = List.empty(growable: true);
  List<Rule> rules = List.empty(growable: true);

  ComplexRule(int id, String rules) : super(id) {
    this._ruleIds = rules.split(' ').map((e) => int.parse(e)).toList();
  }

  void resolve(Map<int, Rule> rules) {
    this.rules.clear();
    for (var id in _ruleIds) {
      if (!rules.containsKey(id)) {
        throw new Exception('Cannot resolve rule #${id}');
      }
      this.rules.add(rules[id]!);
    }
  }

  @override
  Iterable<int> match(String message, int index) {
    Iterable<int> offsets = [0];
    for (var rule in rules) {
      offsets = offsets.expand((o1) => rule.match(message, index + o1).map((o2) => o1 + o2));
    }
    return offsets;
  }
}

class OrRule extends Rule {
  late ComplexRule rule1;
  late ComplexRule rule2;

  OrRule(int id, String rules) : super(id) {
    var vals = rules.split(' | ');
    this.rule1 = new ComplexRule(-1, vals[0]);
    this.rule2 = new ComplexRule(-1, vals[1]);
  }

  @override
  Iterable<int> match(String message, int index) => rule1.match(message, index).followedBy(rule2.match(message, index));
}

class Day19 extends BaseDay {
  Day19({Key? key}) : super(day: 19, key: key);

  @override
  _Day19 createState() => _Day19();
}

class _Day19 extends BaseDayState<Day19> {
  late Rule rule0;
  late List<String> messages;
  late Map<int, Rule> allRules;

  @override
  Future execute() async {
    await loadInput();

    part1Value = await part1();
    part2Value = await part2();

    await super.execute();
  }

  void addRule(Rule rule) {
    if (allRules.containsKey(rule.id)) {
      throw new Exception('Duplicate rule');
    }
    allRules[rule.id] = rule;
  }

  Future<void> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    allRules = new Map();

    for (var i = 0; i < strings.length; i++) {
      var line = strings[i];
      if (line == '') {
        messages = strings.getRange(i + 1, strings.length).toList();
        break;
      } else {
        var vals = line.split(': ');
        var id = int.parse(vals[0]);
        if (vals[1][0] == '"') {
          addRule(new SimpleRule(id, vals[1][1]));
        } else if (vals[1].indexOf('|') >= 0) {
          addRule(new OrRule(id, vals[1]));
        } else {
          addRule(new ComplexRule(id, vals[1]));
        }
      }
    }
    rule0 = allRules[0]!;
  }

  resolveRules() {
    allRules.values.forEach((r) {
      if (r is ComplexRule) {
        r.resolve(allRules);
      } else if (r is OrRule) {
        r.rule1.resolve(allRules);
        r.rule2.resolve(allRules);
      }
    });
  }

  int countMatches() {
    var total = 0;

    for (var message in this.messages) {
      var indexes = rule0.match(message, 0);
      if (indexes.any((idx) => idx == message.length)) {
        total++;
      }
    }
    return total;
  }

  Future<int> part1() async {
    resolveRules();
    return countMatches();
  }

  Future<int> part2() async {
    allRules[8] = new OrRule(8, "42 | 42 8");
    allRules[11] = new OrRule(11, "42 31 | 42 11 31");

    resolveRules();

    return countMatches();
  }
}
