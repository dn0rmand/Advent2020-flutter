library baseDay;

import 'package:flutter/material.dart';
import 'package:timing/timing.dart';

abstract class BaseDay extends StatefulWidget {
  BaseDay({Key? key, this.day}) : super(key: key);

  final int? day;
}

class BaseDayState<T extends BaseDay> extends State<T> {
  bool done = false;
  int part1Value = 0, part2Value = 0;
  Duration? duration;

  @override
  initState() {
    part1Value = 0;
    part2Value = 0;
    super.initState();

    internalExecute();
  }

  void internalExecute() async {
    var tracker = AsyncTimeTracker();
    await tracker.track(() async {
      await execute();
    });
    this.duration = tracker.duration;
    setState(() {
      this.done = true;
    });
  }

  Future execute() async {}

  Widget getContent() {
    if (!done) {
      return CircularProgressIndicator();
    } else {
      var style = new TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent);
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Text('Part 1', style: style),
            Text('$part1Value', style: Theme.of(context).textTheme.headlineMedium),
            Text('Part 2', style: style),
            Text('$part2Value', style: Theme.of(context).textTheme.headlineMedium),
            Text('Executed in', style: style),
            Text('$duration', style: Theme.of(context).textTheme.titleLarge),
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Day ${widget.day}', style: Theme.of(context).textTheme.headlineMedium)),
      body: Center(child: getContent()),
    );
  }
}
