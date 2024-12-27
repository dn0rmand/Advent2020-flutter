import 'package:flutter/services.dart';

class Helper {
  static const String AppTitle = 'Advent of Code 2020';

  static Future<List<String>> loadData(int? day) async {
    var content = await rootBundle.loadString('data/day$day.data');

    return content.split('\n');
  }
}
