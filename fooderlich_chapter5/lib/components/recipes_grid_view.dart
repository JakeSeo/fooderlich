import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';

class RecipesGridView extends StatelessWidget {
  // 1 "RecipesGridView" requires a list of recipes to display in a grid.
  final List<SimpleRecipe> recipes;

  const RecipesGridView({
    Key? key,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2 Apply a 16 point padding on the left, right, and top.
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      // 3 Create a "GridView.builder", which displays only the items visible on
      // screen.
      child: GridView.builder(
        // 4 Tell the grid view how many items will be in the grid.
        itemCount: recipes.length,
        // 5 Add "SilverGridDelegateWithFixedCrossAxisCount" and set the
        // "crossAxisCount" to 2.
        // That means that there will be only two columns.
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemBuilder: (context, index) {
          // 6 Fore every index, fetch the recipe and create a corresponding
          // "RecipeThumbnail".
          final simpleRecipe = recipes[index];
          return RecipeThumbnail(recipe: simpleRecipe);
        },
      ),
    );
  }
}
