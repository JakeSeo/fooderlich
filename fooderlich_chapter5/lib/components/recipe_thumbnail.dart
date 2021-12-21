import 'package:flutter/material.dart';

import '../models/models.dart';

class RecipeThumbnail extends StatelessWidget {
  // 1 This class requires a "SimpleRecipe" as a parameter. That helps configure
  // your widget.
  final SimpleRecipe recipe;

  const RecipeThumbnail({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2 Create a "Container" with 8-point padding all around.
    return Container(
      padding: const EdgeInsets.all(8),
      // 3 Use a "Column" to apply a vertical layout.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4 The first element of the column is "Expanded", which widget holds
          // on to an "Image".
          // You want the image to fill the remaining space.
          Expanded(
            // 5 The "Image" is within the "ClipRRect", which clips the image to
            // make the borders rounded.
            child: ClipRRect(
              child: Image.asset(
                '${recipe.dishImage}',
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // 6 Add some room between the image and the other widgets.
          const SizedBox(height: 10),
          // 7 Add the remaining "Text"s: one to display the recipe's title and
          // another to display the duration.
          Text(
            recipe.title,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            recipe.duration,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
