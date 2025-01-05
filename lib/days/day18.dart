library day18;

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

enum TokenType { number, plus, times, open, close, EOF }

class Token {
  late TokenType _type;
  late int _value;

  Token(TokenType type, int value) {
    _type = type;
    _value = value;
  }

  TokenType get type => _type;
  int get value => _value;

  String toString() {
    switch (_type) {
      case TokenType.plus:
        return "+";
      case TokenType.times:
        return "*";
      case TokenType.number:
        return _value.toString();

      default:
        return "?";
    }
  }
}

abstract class Calculator {
  int get value;

  void add(Token token);

  Calculator create();
}

class CalculatorV1 extends Calculator {
  @override
  Calculator create() {
    return new CalculatorV1();
  }

  int _value = 0;
  TokenType op = TokenType.EOF;

  @override
  int get value {
    if (op != TokenType.open) {
      throw new Exception('Expecting number');
    }
    return _value;
  }

  @override
  void add(Token token) {
    if (op == TokenType.EOF) {
      if (token.type != TokenType.number) {
        throw new Exception('Expecting number');
      }
      _value = token.value;
      op = TokenType.open;
    } else if (op == TokenType.open) {
      // token needs to be an operation
      if (token.type != TokenType.plus && token.type != TokenType.times) {
        throw new Exception('Expecting + or *');
      }
      op = token.type;
    } else if (token.type != TokenType.number) {
      throw new Exception('Expecting number');
    } else {
      if (op == TokenType.plus) {
        _value += token.value;
      } else {
        _value *= token.value;
      }
      op = TokenType.open;
    }
  }
}

class CalculatorV2 extends Calculator {
  @override
  Calculator create() {
    return new CalculatorV2();
  }

  List<Token> tokens = List.empty(growable: true);
  TokenType op = TokenType.number;

  @override
  int get value => eval();

  int eval() {
    // Process the + first
    for (var i = 1; i < tokens.length; i += 2) {
      if (tokens[i].type == TokenType.plus) {
        var v1 = tokens[i - 1].value;
        var v2 = tokens[i + 1].value;
        tokens[i - 1] = new Token(TokenType.number, v1 + v2);
        tokens.removeAt(i + 1);
        tokens.removeAt(i);
        i -= 2;
      }
    }
    // Now do the multiplications
    var value = 1;
    for (var i = 0; i < tokens.length; i += 2) {
      value *= tokens[i].value;
    }
    return value;
  }

  @override
  void add(Token token) {
    if (op == TokenType.open) {
      // token needs to be an operation
      if (token.type != TokenType.plus && token.type != TokenType.times) {
        throw new Exception('Expecting + or *');
      }
      op = token.type;
      tokens.add(token);
    } else if (token.type != TokenType.number) {
      throw new Exception('Expecting number');
    } else {
      op = TokenType.open;
      tokens.add(token);
    }
  }
}

class Parser {
  String data = '';
  int position = 0;

  Parser(String input) {
    data = input;
    position = 0;
  }

  skipSpaces() {
    while (position < data.length && data[position] == ' ') {
      position++;
    }
  }

  int getDigit(bool moveForward) {
    if (position >= data.length) {
      return -1;
    }
    var digit = data.codeUnitAt(position) ^ 0x30;
    if (digit >= 0 && digit <= 9) {
      if (moveForward) {
        position++;
      }
      return digit;
    }
    return -1;
  }

  Token next() {
    skipSpaces();
    if (position >= data.length) {
      return new Token(TokenType.EOF, 0);
    }
    if (getDigit(false) >= 0) {
      var digit = 0;
      var value = 0;
      while (digit >= 0) {
        value = (value * 10) + digit;
        digit = getDigit(true);
      }
      var token = new Token(TokenType.number, value);
      return token;
    }

    var c = data[position++];
    switch (c) {
      case '(':
        return new Token(TokenType.open, 0);
      case ')':
        return new Token(TokenType.close, 0);
      case '+':
        return new Token(TokenType.plus, 0);
      case '*':
        return new Token(TokenType.times, 0);
      default:
        throw new Exception("Syntax error");
    }
  }
}

class Day18 extends BaseDay {
  Day18({Key? key}) : super(day: 18, key: key);

  @override
  _Day18 createState() => _Day18();
}

class _Day18 extends BaseDayState<Day18, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<List<String>> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    return strings;
  }

  int evaluatePart1(Parser formula, Calculator calculator, int deep) {
    var done = false;
    calculator = calculator.create(); // create new instance of same class
    while (!done) {
      var token = formula.next();
      switch (token.type) {
        case TokenType.EOF:
          if (deep != 0) {
            throw new Exception('Syntax error');
          }
          done = true;
          break;
        case TokenType.close:
          if (deep == 0) {
            throw new Exception('Syntax error');
          }
          done = true;
          break;
        case TokenType.open:
          calculator.add(new Token(TokenType.number, evaluatePart1(formula, calculator, deep + 1)));
          break;
        case TokenType.plus:
        case TokenType.times:
        case TokenType.number:
          calculator.add(token);
          break;
      }
    }
    return calculator.value;
  }

  Future<int> part1(List<String> input) async {
    var total = 0;
    for (var s in input) {
      total += evaluatePart1(new Parser(s), new CalculatorV1(), 0);
    }
    return total;
  }

  Future<int> part2(List<String> input) async {
    var total = 0;
    for (var s in input) {
      total += evaluatePart1(new Parser(s), new CalculatorV2(), 0);
    }
    return total;
  }
}
