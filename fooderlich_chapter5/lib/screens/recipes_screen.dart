import 'package:flutter/material.dart';

import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';
import '../components/components.dart';

class RecipesScreen extends StatelessWidget {
  // 1 Create a mock service.
  final exploreService = MockFooderlichService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2 Create a "FutureBuilder".
    return FutureBuilder(
      // 3 Use "getRecipes()" to return the list of recipes to display.
      // This function returns a future list of "SimpleRecipe"s.
      future: exploreService.getRecipes(),
      builder: (context, AsyncSnapshot<List<SimpleRecipe>> snapshot) {
        // 4 Check if the future is complete.
        if (snapshot.connectionState == ConnectionState.done) {
          return RecipesGridView(recipes: snapshot.data ?? []);
        } else {
          // 6 Show a circular loading indicator if the future isn't complete
          // yet.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
