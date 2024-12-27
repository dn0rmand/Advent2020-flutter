import 'package:flutter/material.dart';
import 'helper.dart';

import 'days/day1.dart';
import 'days/day2.dart';
import 'days/day3.dart';
import 'days/day4.dart';
import 'days/day5.dart';
import 'days/day6.dart';
import 'days/day7.dart';
import 'days/day8.dart';
import 'days/day9.dart';
import 'days/day10.dart';
import 'days/day11.dart';
import 'days/day12.dart';
import 'days/day13.dart';
import 'days/day14.dart';
import 'days/day15.dart';
import 'days/day16.dart';
import 'days/day17.dart';
import 'days/day18.dart';
import 'days/day19.dart';
import 'days/day20.dart';
import 'days/day21.dart';
import 'days/day22.dart';
import 'days/day23.dart';
import 'days/day24.dart';
import 'days/day25.dart';

void main() {
  runApp(Advent2020App());
}

class Advent2020App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Helper.AppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void executeDay(int i) {
    var ctor = (BuildContext context) {
      switch (i) {
        case 1:
          return Day1();
        case 2:
          return Day2();
        case 3:
          return Day3();
        case 4:
          return Day4();
        case 5:
          return Day5();
        case 6:
          return Day6();
        case 7:
          return Day7();
        case 8:
          return Day8();
        case 9:
          return Day9();
        case 10:
          return Day10();
        case 11:
          return Day11();
        case 12:
          return Day12();
        case 13:
          return Day13();
        case 14:
          return Day14();
        case 15:
          return Day15();
        case 16:
          return Day16();
        case 17:
          return Day17();
        case 18:
          return Day18();
        case 19:
          return Day19();
        case 20:
          return Day20();
        case 21:
          return Day21();
        case 22:
          return Day22();
        case 23:
          return Day23();
        case 24:
          return Day24();
        case 25:
          return Day25();
      }
      throw Error();
    };

    var route = MaterialPageRoute(
      builder: ctor,
    );

    Navigator.of(context).push(route);
  }

  List<Widget> getButtons() {
    var buttons = List<Widget>.empty(growable: true);

    for (var i = 1; i <= 25; i++) {
      var button = ElevatedButton(onPressed: () => executeDay(i), child: Text('Day $i', style: TextStyle(fontSize: 20)));
      buttons.add(SizedBox(
        width: 120,
        height: 30,
        child: button,
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Helper.AppTitle),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: getButtons(),
        ),
      ),
    );
  }
}
