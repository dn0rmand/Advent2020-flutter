library day22;

import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class DeckKey {
  int? hash = null;
  late int p1Length;
  late List<int> cards;

  DeckKey(Deck player1, Deck player2) {
    p1Length = player1.length;
    cards = player1.cards.followedBy([0]).followedBy(player2.cards).toList(growable: false);
  }

  @override
  int get hashCode {
    if (hash == null) {
      hash = 2166136261;
      cards.forEach((card) {
        hash = (hash! * 16777619) ^ card;
      });
    }
    return hash!;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is DeckKey)) {
      return false;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (p1Length != other.p1Length) {
      return false;
    }
    for (var i = 0; i < cards.length; i++) {
      if (cards[i] != other.cards[i]) {
        return false;
      }
    }
    return true;
  }
}

class Deck {
  List<int> cards = new List.empty(growable: true);

  int get length => cards.length;
  int get max {
    return cards.fold<int>(0, (m, v) => m < v ? v : m);
  }

  Deck clone(int length) {
    var deck = new Deck();

    deck.cards = this.cards.getRange(0, length).toList();

    return deck;
  }

  void push(int card) {
    cards.add(card);
  }

  int pop() {
    var card = cards.first;
    cards.removeAt(0);
    return card;
  }

  int get score {
    var score = 0;
    for (var i = cards.length, value = 1; i > 0; i--, value++) {
      score += cards[i - 1] * value;
    }
    return score;
  }
}

class Game {
  Deck player1 = new Deck();
  Deck player2 = new Deck();

  Game clone() {
    var game = new Game();
    game.player1 = player1.clone(player1.length);
    game.player2 = player2.clone(player2.length);
    return game;
  }

  int playCrabCombat() {
    while (player1.length > 0 && player2.length > 0) {
      var p1 = player1.pop();
      var p2 = player2.pop();
      if (p1 > p2) {
        player1.push(p1);
        player1.push(p2);
      } else {
        player2.push(p2);
        player2.push(p1);
      }
    }

    return player1.score + player2.score;
  }

  int recurse(Deck player1, Deck player2) {
    if (player1.max > player2.max) {
      return 1;
    }

    int winner;

    var visited = new HashSet<DeckKey>();
    while (player1.length > 0 && player2.length > 0) {
      var key = new DeckKey(player1, player2);
      if (visited.contains(key)) {
        return 1; // Player 1 wins
      }
      visited.add(key);

      var p1 = player1.pop();
      var p2 = player2.pop();

      if (p1 <= player1.length && p2 <= player2.length) {
        // recurse
        winner = recurse(player1.clone(p1), player2.clone(p2));
      } else {
        winner = p1 > p2 ? 1 : 2;
      }

      if (winner == 1) {
        player1.push(p1);
        player1.push(p2);
      } else {
        player2.push(p2);
        player2.push(p1);
      }
    }

    winner = player1.length > 0 ? 1 : 2;

    return winner;
  }

  int playRecursiveCombat() {
    var visited = new HashSet<DeckKey>();

    while (player1.length > 0 && player2.length > 0) {
      var key = new DeckKey(player1, player2);
      if (visited.contains(key)) {
        return player1.score; // Player 1 wins
      }
      visited.add(key);

      var p1 = player1.pop();
      var p2 = player2.pop();
      int winner;

      if (p1 <= player1.length && p2 <= player2.length) {
        // recurse
        winner = recurse(player1.clone(p1), player2.clone(p2));
      } else {
        winner = p1 > p2 ? 1 : 2;
      }

      if (winner == 1) {
        player1.push(p1);
        player1.push(p2);
      } else {
        player2.push(p2);
        player2.push(p1);
      }
    }

    return player1.score + player2.score;
  }
}

class Day22 extends BaseDay {
  Day22({Key? key}) : super(day: 22, key: key);

  @override
  _Day22 createState() => _Day22();
}

class _Day22 extends BaseDayState<Day22, int, int> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<Game> loadInput() async {
    var strings = await Helper.loadData(widget.day);
    var game = new Game();

    int index = 1;

    while (index < strings.length) {
      if (strings[index].isEmpty) {
        index += 2;
        break;
      }
      game.player1.push(int.parse(strings[index++]));
    }

    while (index < strings.length) {
      game.player2.push(int.parse(strings[index++]));
    }

    return game;
  }

  Future<int> part1(Game game) async {
    var game2 = game.clone();
    return game2.playCrabCombat();
  }

  Future<int> part2(Game game) async {
    return game.playRecursiveCombat();
  }
}
