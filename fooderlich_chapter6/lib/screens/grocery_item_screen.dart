import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../components/grocery_tile.dart';

class GroceryItemScreen extends StatefulWidget {
  // 1 "onCreate" is a callback that lets you know when a new item is created.
  final Function(GroceryItem) onCreate;
  // 2 "onUpdate" is a callback that returns the updated grocery item.
  final Function(GroceryItem) onUpdate;
  // 3 The grocery item that the user clicked.
  final GroceryItem? originalItem;
  // 4 "isUpdating" determines whether the user is creating or editing an item.
  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    // 1 When the "originalItem" is not null, the user is editing an
    // existing item. In this case, you must configure the widget to show
    // the item's values.
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    // 2 Adds a listener to listen for text field changes.
    // When the text changes, you set the "_name".
    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1 "Scaffold" defines the main layout and structure of the entire screen.
    return Scaffold(
      // 2 Includes an app bar with one action button. The user will tap
      // this button when they've finished creating an item.
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 1 When the user taps "Save", you take all the state properties
              // and create a "GroceryItem".
              final groceryItem = GroceryItem(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                name: _nameController.text,
                importance: _importance,
                color: _currentColor,
                quantity: _currentSliderValue,
                date: DateTime(
                  _dueDate.year,
                  _dueDate.month,
                  _dueDate.day,
                  _timeOfDay.hour,
                  _timeOfDay.minute,
                ),
              );

              if (widget.isUpdating) {
                // 2 If the user is updating an existing item, call "onUpdate".
                widget.onUpdate(groceryItem);
              } else {
                // 3 If the user is creating a new item, call "onCreate".
                widget.onCreate(groceryItem);
              }
            },
          )
        ],
        // 3 Sets elevation to "0.0", removing the shadow under the app bar.
        elevation: 0.0,
        // 4 Sets the title of the app bar.
        title: Text(
          'Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      // 5 Shows a "ListView", padded by 16 pixels on every side, within
      // the body of the scaffold.
      // You'll fill this list view with a bunch of interactive widgets soon.
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildNameField(),
            buildImportanceField(),
            buildDateField(context),
            buildTimeField(context),
            const SizedBox(height: 10.0),
            buildColorPicker(context),
            const SizedBox(height: 10.0),
            buildQuantityField(),
            GroceryTile(
              item: GroceryItem(
                id: 'previewMode',
                name: _name,
                importance: _importance,
                color: _currentColor,
                quantity: _currentSliderValue,
                date: DateTime(
                  _dueDate.year,
                  _dueDate.month,
                  _dueDate.day,
                  _timeOfDay.hour,
                  _timeOfDay.minute,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    // 1 Creates a "Column" to lay elements out vertically.
    return Column(
      // 2 Aligns all widgets in the column to the left.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3 Adds a "Text" that's styled using "GoogleFonts".
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        // 4 Adds a "TextField" to enter the name of the item.
        TextField(
          // 5 Sets the "TextField"'s "TextEditingController".
          controller: _nameController,
          // 6 Sets the cursor color.
          cursorColor: _currentColor,
          // 7 Styles the text field using "InputDecoration".
          decoration: InputDecoration(
            // 8 Includes a hint to give users an example of what to write.
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            // 9 Customizes the text field's border color.
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImportanceField() {
    // 1 Use a "Column" to lay out the widgets vertically.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2 Add "Text".
        Text(
          'Importance',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        // 3 Add "Wrap" and space each child widget 10 pixels apart.
        // "Wrap" lays out children horizontally.
        // When tehre's no more room, it wraps to the next line.
        Wrap(
          spacing: 10.0,
          children: [
            // 4 Create a "ChoiceChip" for the user to select the lowe priority.
            ChoiceChip(
              // 5 Set the selected chips background color to black.
              selectedColor: Colors.black,
              // 6 Check whether the user selected this ChoiceChip.
              selected: _importance == Importance.low,
              label: const Text(
                'low',
                style: TextStyle(color: Colors.white),
              ),
              // 7 Update "_importance", if the user selected this choice.
              onSelected: (selected) {
                setState(() => _importance = Importance.low);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.medium,
              label: const Text(
                'medium',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.medium);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.high,
              label: const Text(
                'high',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.high);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildDateField(BuildContext context) {
    // 1 Adds a "Column" to lay out elements vertically.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2 Adds a "Row" to lay out elements horizontally.
        Row(
          // 3 Adds a space between elements in the row.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 4 Adds the date "Text".
            Text(
              'Date',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            // 5 Adds a "TextButton" to confirm the selected value.
            TextButton(
              child: const Text('Select'),
              // 6 Gets the current date when the user presses the button.
              onPressed: () async {
                final currentDate = DateTime.now();
                // 7 Presents the date picker. You restrict the date picker and
                // only allow the user to pick a date from today until
                // five years in the future.
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 5),
                );
                // 8 Sets "_dueDate" after the user selects a date.
                setState(() {
                  if (selectedDate != null) {
                    _dueDate = selectedDate;
                  }
                });
              },
            ),
          ],
        ),
        // 9 Format the current date and display it with a "Text".
        Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
      ],
    );
  }

  Widget buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time of Day',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                // 1 Shows the time picker when the user taps the Select button.
                final timeOfDay = await showTimePicker(
                  // 2 Sets the initial time displayed in the time picker to the
                  // current time.
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                // 3 Once the user selects the time widget, it updates
                // "_timeOfDay".
                setState(() {
                  if (timeOfDay != null) {
                    _timeOfDay = timeOfDay;
                  }
                });
              },
            ),
          ],
        ),
        Text('${_timeOfDay.format(context)}'),
      ],
    );
  }

  Widget buildColorPicker(BuildContext context) {
    // 1 Adds a "Row" widget to layout the color picker section in the
    // horizontal direction.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 2 Creates a child "Row" and groups the following widgets:
        // * A "Container" to display the selected color.
        // * An 8-pixel-wide "SizedBox".
        // * A "Text" to display the color picker's title.
        Row(
          children: [
            Container(
              height: 50.0,
              width: 10.0,
              color: _currentColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Color',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
          ],
        ),
        // 3 Adds a "TextButton".
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            // 4 Shows a pop-up dialog when the user taps the button.
            showDialog(
              context: context,
              builder: (context) {
                // 5 Wraps "BlockPicker" inside "AlertDialog".
                return AlertDialog(
                  content: BlockPicker(
                    pickerColor: Colors.white,
                    // 6 Updates "_currentColor" when the user selects a color.
                    onColorChanged: (color) {
                      setState(() => _currentColor = color);
                    },
                  ),
                  actions: [
                    // 7 Adds an action button in the dialog. When the user taps
                    // "Save", it dismisses the dialog.
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildQuantityField() {
    // 1 Lay out your widgets vertically, using a "Column".
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2 Add a title and the quantity labels to the quantity section by
        // creating a "Row" that contains two "Text"s. You use a "SizedBox"
        // to separate the "Text"s.
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Quantity',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              _currentSliderValue.toInt().toString(),
              style: GoogleFonts.lato(fontSize: 18.0),
            ),
          ],
        ),
        // 3 Add a "Slider".
        Slider(
          // 4 Set the active and inactive colors.
          inactiveColor: _currentColor.withOpacity(0.5),
          activeColor: _currentColor,
          // 5 Set the current slider value.
          value: _currentSliderValue.toDouble(),
          // 6 Set the slider's minimum and maximum value.
          min: 0.0,
          max: 100.0,
          // 7 Set how you want the slider to increment.
          divisions: 100,
          // 8 Set the label above the slider. Here, you want to show the
          // current value above the slider.
          label: _currentSliderValue.toInt().toString(),
          // 9 Update "_currentSliderValue" when the value changes.
          onChanged: (double value) {
            setState(
              () {
                _currentSliderValue = value.toInt();
              },
            );
          },
        ),
      ],
    );
  }
}
