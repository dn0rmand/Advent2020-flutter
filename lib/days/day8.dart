import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';
import '../vm.dart';

class Day8 extends BaseDay {
  Day8({Key? key}) : super(day: 8, key: key);

  @override
  _Day8 createState() => _Day8();
}

class _Day8 extends BaseDayState<Day8> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<VirtualMachine> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    return VirtualMachine.compile(strings);
  }

  Future<int> part1(VirtualMachine vm) async {
    vm.execute();
    return vm.accu;
  }

  Future<int> part2(VirtualMachine vm) async {
    var jmps = vm.find(OpCode.JMP).where((i) => (i.address + i.value) <= vm.program.length).toList();
    var nops = vm.find(OpCode.NOP).where((i) => (i.address + i.value) <= vm.program.length).toList();

    var lastJmp = jmps.last;

    for (var i in nops.where((i) => (i.address + i.value) > lastJmp.address)) {
      i.opcode = OpCode.JMP;
      if (vm.execute()) {
        return vm.accu;
      }
      i.opcode = OpCode.NOP;
    }

    for (var i in jmps.reversed) {
      i.opcode = OpCode.NOP;
      if (vm.execute()) {
        return vm.accu;
      }
      i.opcode = OpCode.JMP;
    }

    return -1;
  }
}
