import 'package:flutter/material.dart';

// 1 Import the barrel files, component.dart and models.dart, so you can use
// data models and UI components.
import '../components/components.dart';
import '../models/models.dart';

class TodayRecipeListView extends StatelessWidget {
  // 2 "TodayRecipeListView" needs a list of recipes to display.
  final List<ExploreRecipe> recipes;

  const TodayRecipeListView({
    Key? key,
    required this.recipes,
  }) : super(key: key);

  Widget buildCard(ExploreRecipe recipe) {
    if (recipe.cardType == RecipeCardType.card1) {
      return Card1(recipe: recipe);
    } else if (recipe.cardType == RecipeCardType.card2) {
      return Card2(recipe: recipe);
    } else if (recipe.cardType == RecipeCardType.card3) {
      return Card3(recipe: recipe);
    } else {
      throw Exception('This card doesn\'t exist yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3 Within "build()", start by applying some padding.
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      // 4 Add a "Colun" to place widgets in a vertical layout.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 5 In the column, add a "Text". This is the header for the
          // Recipes of the Day.
          Text('Recipes of the Day 🍳',
              style: Theme.of(context).textTheme.headline1),
          // 6 Add a 16-point-tall "SizedBox", to supply some padding.
          const SizedBox(height: 16),
          // 7 Add a "Container", 400 points tall, and set the background color
          // to grey. This container will hold your horizontal list view.
          Container(
            height: 400,
            // 1 Change the color from grey to transparent.
            color: Colors.transparent,
            // 2 Create "ListView.separated". Remember, this widget creates two
            // "IndexedWidgetBuilder"s.
            child: ListView.separated(
              // 3 Set the scroll direction to the "horizontal" axis
              scrollDirection: Axis.horizontal,
              // 4 Set the number of items in the list view.
              itemCount: recipes.length,
              // 5 Create the "itemBuilder" callback, which will go through
              // every item in the list.
              itemBuilder: (context, index) {
                // 6 Get the recipe for the current index and build the card.
                final recipe = recipes[index];
                return buildCard(recipe);
              },
              // 7 Create the "separatorBuilder" callback, which will go
              // through every item in the list.
              separatorBuilder: (context, index) {
                // 8 For every item, you create a "SizedBox" to space every item
                // 16 points apart.
                return const SizedBox(width: 16);
              },
            ),
          ),
        ],
      ),
    );
  }
}
