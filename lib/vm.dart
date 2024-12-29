enum OpCode {
  ACC,
  JMP,
  NOP,
}

class Instruction {
  int address = 0;
  OpCode opcode = OpCode.NOP;
  int value = 0;

  Instruction(OpCode opcode, int value, int address) {
    this.opcode = opcode;
    this.value = value;
    this.address = address;
  }
}

class VirtualMachine {
  List<Instruction> program = List.empty(growable: true);
  int accu = 0;

  static VirtualMachine compile(List<String> code) {
    var vm = new VirtualMachine();
    for (var line in code) {
      var i = line.split(' ');
      OpCode opcode;
      int value = int.parse(i[1]);
      switch (i[0]) {
        case 'acc':
          opcode = OpCode.ACC;
          break;
        case 'jmp':
          opcode = OpCode.JMP;
          break;
        case 'nop':
          opcode = OpCode.NOP;
          break;
        default:
          throw new Exception("Syntax error");
      }

      vm.program.add(new Instruction(opcode, value, vm.program.length));
    }
    return vm;
  }

  List<Instruction> find(OpCode opcode) => program.where((i) => i.opcode == opcode).toList();

  bool execute() {
    var ip = 0;
    var visited = List<bool>.filled(program.length, false);

    accu = 0;

    while (ip < program.length) {
      if (visited[ip]) {
        return false;
      }

      visited[ip] = true;

      switch (program[ip].opcode) {
        case OpCode.ACC:
          accu += program[ip].value;
          ip++;
          break;
        case OpCode.JMP:
          ip += program[ip].value;
          break;
        case OpCode.NOP:
          ip++;
          break;
      }
    }

    return true;
  }
}
