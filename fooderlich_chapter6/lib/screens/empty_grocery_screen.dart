import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1 "Padding": Adds 30 pixels on all sides.
    return Padding(
      padding: const EdgeInsets.all(30.0),
      // 2 "Center": Places all the other widgets in the center.
      child: Center(
        // 3 "Column": Handles the vertical layouts of the other widgets.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1 "Flexible" gives a child the ability to fill the available
            // space in the main axis
            Flexible(
              // 2 "AspectRatio" sizes its child to the specified "aspectRatio".
              // Although "aspectRatio" is a double, the Flutter documentation
              // recommends writing it as width / height instead of the
              // calculated result. In this case, you want a square aspect ratio
              // of "1/1" and not "1.0".
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset('assets/fooderlich_assets/empty_list.png'),
              ),
            ),
            Text(
              'No Groceries',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Shopping for ingredients?\n'
              'Tap the + button to write them down!',
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              textColor: Colors.white,
              child: const Text('Browse Recipes'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.green,
              onPressed: () {
                Provider.of<TabManager>(context, listen: false).goToRecipes();
              },
            ),
          ],
        ),
      ),
    );
  }
}
