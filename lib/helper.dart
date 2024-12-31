import 'dart:ffi';

import 'package:flutter/services.dart';

class Helper {
  static const String AppTitle = 'Advent of Code 2020';

  static Future<List<String>> loadData(int? day) async {
    var content = await rootBundle.loadString('data/day$day.data');

    return content.split('\n');
  }

  static int gcd(int a, int b) {
    while (b != 0) {
      var tmp = a % b;
      a = b;
      b = tmp;
    }
    return a;
  }

  static int lcm(int a, int b) => (a ~/ gcd(a, b)) * b;

  static int chineseRemainder(int p, int q, int a, int b) {
    var pq = p * q;
    var s = (q.modInverse(p) * q) % pq;
    var m1 = (a * s) % pq;
    if (b == 0) {
      return m1;
    } else {
      var t = (p * p.modInverse(q)) % pq;
      var m2 = (b * t) % pq;
      return (m1 + m2) % pq;
    }
  }
}
