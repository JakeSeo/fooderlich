import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

// 1 You import Chopper to create instances of "Response".
import 'package:chopper/chopper.dart';
// 2 "show" means that you want a specific class or classes to be visible in
// your app. In this case, you want "rootBundle" to be visible for loading JSON
// files.
import 'package:flutter/services.dart' show rootBundle;
import '../network/model_response.dart';
import '../network/recipe_model.dart';

class MockService {
  // 1 Use "_currentRecipes1" and "_currentRecipes2" to store the results loaded
  // from the two JSON files.
  late APIRecipeQuery _currentRecipes1;
  late APIRecipeQuery _currentRecipes2;
  // 2 "nextRecipe" is an instance of "Random" that creates a number between 0
  // and 1.
  Random nextRecipe = Random();
  // 3 The "create()" method, which "Provider" will call, just calls
  // "loadRecipes()".
  void create() {
    loadRecipes();
  }

  void loadRecipes() async {
    // 4 "rootBundle" loads the JSON file as a string.
    var jsonString = await rootBundle.loadString('assets/recipes1.json');
    // 5 "jsonDecode()" reates a map that "APIRecipeQuery" will use to get a
    // list of recipes.
    _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
    jsonString = await rootBundle.loadString('assets/recipes2.json');
    _currentRecipes2 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
  }

  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    // 6 Use your random field to pick a random integer, either 0 or 1.
    switch (nextRecipe.nextInt(2)) {
      case 0:
        // 7 Wrap your APIRecipeQuery" result in "Success", "Response" and
        // Future.
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1)));
      case 1:
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes2)));
      default:
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1)));
    }
  }
}
