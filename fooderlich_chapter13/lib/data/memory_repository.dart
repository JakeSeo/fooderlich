import 'dart:core';
import 'package:flutter/foundation.dart';
// 1 "repository.dart" contains the interface definition.
import 'repository.dart';
// 2 "models.dart" exports the "Recipe" and "Ingredient" class definition.
import 'models/models.dart';

// 3 "MemoryRepository" extends "Repository" and uses Flutter's "changeNotifier"
// to enable listeners and notify those listeners of any changes.
class MemoryRepository extends Repository with ChangeNotifier {
  // 4 You initialize your current list of recipes.
  final List<Recipe> _currentRecipes = <Recipe>[];
  // 5 Then you initialize your current list of ingredients.
  final List<Ingredient> _currentIngredients = <Ingredient>[];

  @override
  List<Recipe> findAllRecipes() {
    // 7 Returns your current "RecipeList".
    return _currentRecipes;
  }

  @override
  Recipe findRecipeById(int id) {
    // 8 Uses "firstWhere" to find a recipe with the given ID.
    return _currentRecipes.firstWhere((recipe) => recipe.id == id);
  }

  @override
  List<Ingredient> findAllIngredients() {
    // 9 Returns your current ingredient list.
    return _currentIngredients;
  }

  @override
  List<Ingredient> findRecipeIngredients(int recipeId) {
    // 10 Finds a recipe with the given ID.
    final recipe =
        _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);
    // 11 Uses "where" to find all the ingredients with the given recipe ID.
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();
    return recipeIngredients;
  }

  @override
  int insertRecipe(Recipe recipe) {
    // 12 Add the recipe to your list.
    _currentRecipes.add(recipe);
    // 13 Call the metod to add all the recipes ingredients.
    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }
    // 14 Notify all listeners of the changes.
    notifyListeners();
    // 15 Return the ID of the new recipe. Since you don't need it, it'll always
    // return 0.
    return 0;
  }

  @override
  List<int> insertIngredients(List<Ingredient> ingredients) {
    // 16 Check to make sure there are some ingredients.
    if (ingredients.length != 0) {
      // 17 Add all the ingredients to your list.
      _currentIngredients.addAll(ingredients);
      // 18 Notify all listeners of the changes.
      notifyListeners();
    }
    // 19 Return the lsit of IDs added. An empty list for now.
    return <int>[];
  }

  @override
  void deleteRecipe(Recipe recipe) {
    // 20 Remove the recipe from your list.
    _currentRecipes.remove(recipe);
    // 21 Delete all the ingredients for this recipe.
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
    // 22 Notify all listeners that the data has changed.
    notifyListeners();
  }

  @override
  void deleteIngredient(Ingredient ingredient) {
    // 23 Remove the ingredients from your list.
    _currentIngredients.remove(ingredient);
  }

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    // 24 Remove all ingredients that are in the passed-in list.
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));
    notifyListeners();
  }

  @override
  void deleteRecipeIngredients(int recipeId) {
    // 25 Go through all ingredients and look for ingredients that have the
    // given recipe ID, then remove them.
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);
    notifyListeners();
  }

  // 6 Since this is a memory repository, you don't need to do anything to
  // initialize and close but you need to implement thse methods.
  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
