import 'models/models.dart';

abstract class Repository {
  // 1 Return all recipes in the repository.
  List<Recipe> findAllRecipes();

  // 2 Find a specific recipe by its ID.
  Recipe findRecipeById(int id);

  // 3 Return all ingredients.
  List<Ingredient> findAllIngredients();

  // 4 Find all the ingredients for the given recipe ID.
  List<Ingredient> findRecipeIngredients(int recipeId);

  // 5 Insert a new reipe.
  int insertRecipe(Recipe recipe);

  // 6 Add all the given ingredients.
  List<int> insertIngredients(List<Ingredient> ingredients);

  // 7 Delete the given recipe
  void deleteRecipe(Recipe recipe);

  // 8 Delete the given ingredient.
  void deleteIngredient(Ingredient ingredient);

  // 9 Delete all the given ingredients.
  void deleteIngredients(List<Ingredient> ingredients);

  // 10 Delete all the ingredients for the given recipe ID.
  void deleteRecipeIngredients(int recipeId);

  // 11 Allow the repository to initialize. Databases might need to do some
  // startup work.
  Future init();
  // 12 Close the repository.
  void close();
}
