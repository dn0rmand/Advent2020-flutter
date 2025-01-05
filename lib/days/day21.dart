library day21;

import 'dart:collection';

import 'package:advent/days/baseDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class Food {
  late List<String> ingredients;
  late List<String> allergens;

  Food(String data) {
    var d = data.split(' (contains ');
    ingredients = d[0].split(' ').toList(growable: false);
    if (d.length > 1) {
      allergens = d[1].substring(0, d[1].length - 1).split(', ').toList(growable: false);
    } else {
      allergens = List.empty(growable: false);
    }
  }
}

class Input {
  late List<String> ingredients;
  late List<String> allergens;
  late List<Food> foods;

  Input(List<Food> foods) {
    var ingredients = new HashSet<String>();
    var allergens = new HashSet<String>();
    foods.forEach((food) {
      allergens.addAll(food.allergens);
      ingredients.addAll(food.ingredients);
    });

    this.foods = foods;
    this.allergens = allergens.toList(growable: false);
    this.ingredients = ingredients.toList(growable: false);
  }
}

class Day21 extends BaseDay {
  Day21({Key? key}) : super(day: 21, key: key);

  @override
  _Day21 createState() => _Day21();
}

class _Day21 extends BaseDayState<Day21, int, String> {
  @override
  Future execute() async {
    var input = await loadInput();

    part1Value = await part1(input);
    part2Value = await part2(input);

    await super.execute();
  }

  Future<Input> loadInput() async {
    var strings = await Helper.loadData(widget.day);

    return new Input(strings.map((e) => new Food(e)).toList(growable: false));
  }

  Map<String, List<String>> getIngredientsPerAllergen(Input input) {
    var ingredientsPerAllergen = new Map<String, List<String>>();

    // Fill
    input.foods.forEach((food) {
      food.allergens.forEach((allergen) {
        if (ingredientsPerAllergen.containsKey(allergen)) {
          var previous = new HashSet<String>.from(ingredientsPerAllergen[allergen]!);
          ingredientsPerAllergen[allergen] =
              food.ingredients.where((ingredient) => previous.contains(ingredient)).toList(growable: false);
        } else {
          ingredientsPerAllergen[allergen] = food.ingredients;
        }
      });
    });

    return ingredientsPerAllergen;
  }

  Future<int> part1(Input input) async {
    var ingredientsPerAllergen = getIngredientsPerAllergen(input);

    // bad ingredients
    var bad = new HashSet<String>.from(ingredientsPerAllergen.values.expand((ingredients) => ingredients));

    var result = input.foods.fold<int>(0, (total, food) {
      var good = food.ingredients.where((ingredient) => !bad.contains(ingredient)).length;
      return total + good;
    });
    return result;
  }

  Future<String> part2(Input input) async {
    var translation = new Map<String, String>();
    var ingredientsPerAllergen = getIngredientsPerAllergen(input);

    while (ingredientsPerAllergen.isNotEmpty) {
      var easy = ingredientsPerAllergen.entries.where((e) => e.value.length == 1).toList();
      if (easy.length == 0) {
        throw new Exception("Dead end");
      }
      easy.forEach((e) {
        ingredientsPerAllergen.remove(e.key);
        if (translation.containsKey(e.value.first)) {
          throw new Exception("Something went wrong");
        }
        translation[e.value.first] = e.key;
      });

      ingredientsPerAllergen.forEach((allergen, ingredients) {
        var filtered = ingredients.where((i) => !translation.containsKey(i));
        if (filtered.isEmpty) {
          ingredientsPerAllergen.remove(allergen);
        } else {
          ingredientsPerAllergen[allergen] = filtered.toList(growable: false);
        }
      });
    }
    if (translation.length != input.allergens.length) {
      return "Error";
    }
    var values = translation.keys.toList();
    values.sort((a, b) {
      var av = translation[a]!;
      var bv = translation[b]!;
      return av.compareTo(bv);
    });

    return values.join(',');
  }
}
