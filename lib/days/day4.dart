library day4;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Day4 extends BaseDay {
  Day4({Key? key}) : super(day: 4, key: key);

  @override
  _Day4 createState() => _Day4();
}

class _Day4 extends BaseDayState<Day4, int, int> {
  List<String> requiredKeys = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
  ];

  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<Map<String, String>>> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    List<Map<String, String>> passports = List.empty(growable: true);
    Map<String, String> passport = new Map();
    for (var i = 0; i < strings.length; i++) {
      var line = strings[i];
      if (line.length == 0) {
        if (passport.length > 0) {
          passports.add(passport);
        }
        passport = new Map();
      } else {
        for (var pair in line.split(' ')) {
          var values = pair.split(':');
          if (values.length != 2) {
            throw new Exception("Syntax error");
          }
          passport[values[0]] = values[1];
        }
      }
    }
    if (passport.length > 0) {
      passports.add(passport);
    }
    return passports;
  }

  Future<int> part1(List<Map<String, String>> passports) async {
    var total = passports.where((passport) => requiredKeys.every((key) => passport.containsKey(key))).length;
    return total;
  }

  Future<int> part2(List<Map<String, String>> passports) async {
    var valid = passports.where((passport) => requiredKeys.every((key) => passport.containsKey(key)));

    // check byr
    valid = valid.where((passport) => ValidateNumber(passport["byr"]!, 4, 1920, 2002));
    // check iyr
    valid = valid.where((passport) => ValidateNumber(passport["iyr"]!, 4, 2010, 2020));
    // check eyr
    valid = valid.where((passport) => ValidateNumber(passport["eyr"]!, 4, 2020, 2030));
    // check hcl
    valid = valid.where((passport) => ValidateHairColor(passport["hcl"]!));
    // check ecl
    valid = valid.where((passport) => ValidateEyeColor(passport["ecl"]!));
    // check pid
    valid = valid.where((passport) => ValidateNumber(passport["pid"]!, 9, 0, 999999999));
    // check hgt
    valid = valid.where((passport) => ValidateHeight(passport["hgt"]!));

    return valid.length;
  }

  bool ValidateNumber(String value, int length, int min, int max) {
    if (value.length != length) {
      return false;
    }
    var year = int.parse(value);
    return year >= min && year <= max;
  }

  bool ValidateEyeColor(String value) {
    switch (value) {
      case "amb":
      case "blu":
      case "brn":
      case "gry":
      case "grn":
      case "hzl":
      case "oth":
        return true;
    }

    return false;
  }

  bool ValidateHairColor(String value) {
    if (value.length != 7 || value[0] != '#') {
      return false;
    }
    List<String> valid = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
    for (var i = 1; i < value.length; i++) {
      var c = value[i];
      if (!valid.contains((c))) {
        return false;
      }
    }
    return true;
  }

  bool ValidateHeight(String value) {
    if (value.endsWith("cm")) {
      var h = int.parse(value.substring(0, value.length - 2));
      return h >= 150 && h <= 193;
    } else if (value.endsWith("in")) {
      var h = int.parse(value.substring(0, value.length - 2));
      return h >= 59 && h <= 76;
    }
    return false;
  }
}
