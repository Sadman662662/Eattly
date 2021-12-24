import 'package:badges/badges.dart';
import 'package:eattlystefan/utils/helper_functions.dart';
import 'package:eattlystefan/widgets/meal_planner/calendar_header.dart';
import 'package:eattlystefan/widgets/meal_planner/date_chips.dart';
import 'package:eattlystefan/widgets/meal_planner/hourly_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/core/app_bar_icon_button.dart';
import '../widgets/core/eattly_app_bar.dart';

class CreateMealPlanScreen extends StatefulWidget {
  static const String routeName = '/create-meal';

  @override
  _CreateMealPlanScreenState createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  final recipes = const [
    {
      'id': '123',
      'imageUrl': 'https://picsum.photos/400/500',
      'name': 'Quinao Salad',
      'description': 'Lorem ipsum dolort',
    },
    {
      'id': '234',
      'imageUrl': 'https://picsum.photos/400/500',
      'name': 'Kalarepa',
      'description': 'Lorem ipsum dolort',
    },
    {
      'id': '345',
      'imageUrl': 'https://picsum.photos/400/500',
      'name': 'Currant Cocktail',
      'description': 'Lorem ipsum dolort',
    },
  ];

  var _descriptionController = TextEditingController();
  DateTime selectedMonth = DateTime.now();
  Map<String, String> selectedRecipe;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> hours = [];
    for (var i = 0; i < 25; i++) {
      hours.add({'startTime': i, 'recipe': null});
    }

    return Scaffold(
      appBar: EattlyAppBar(
        title: 'Add a Meal',
        leading: AppBarIconButton(
          icon: Icons.chevron_left,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              print(selectedRecipe);
              print(_descriptionController.text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF3F3F3),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  right: 10,
                  bottom: 0,
                  left: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Meal Plan',
                      style: TextStyle(
                        color: Color(0xFF262525),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    SelectRecipe(
                      recipes: recipes,
                      onSelect: (int index) => setState(() {
                        selectedRecipe = recipes[index];
                      }),
                    ),
                    SizedBox(height: 20),
                    DescriptionTextField(
                      label: 'Add Description',
                      controller: _descriptionController,
                      hintText: 'Enter a description for this meal.',
                    ),
                    CalendarHeader(
                      selectedMonth: selectedMonth,
                      onNextMonth: _handleNextMonth,
                      onPreviousMonth: _handlePreviousMonth,
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DateChips(selectedMonth: selectedMonth),
                    ),
                    SizedBox(height: 32),
                    Container(
                      height: 300,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: hours
                                .map(
                                  (hour) => HourlyTile(
                                    selectedMonth: selectedMonth,
                                    hour: hour,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNextMonth() {
    setState(() {
      selectedMonth = addMonthsToMonthDate(selectedMonth, 1);
    });
  }

  void _handlePreviousMonth() {
    setState(() {
      selectedMonth = addMonthsToMonthDate(selectedMonth, -1);
    });
  }
}

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({
    Key key,
    @required this.label,
    @required this.controller,
    @required this.hintText,
  })  : assert(label != null),
        assert(controller != null),
        assert(hintText != null),
        super(key: key);

  final String label;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 2,
          decoration: _decoration(),
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  InputDecoration _decoration() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.all(10),
      hintText: 'Enter a description for this meal.',
      fillColor: Colors.white,
      filled: true,
      border: border,
    );
  }
}

class SelectRecipe extends StatefulWidget {
  const SelectRecipe({
    Key key,
    @required this.recipes,
    @required this.onSelect,
  })  : assert(recipes != null),
        assert(onSelect != null),
        super(key: key);

  final List<Map<String, String>> recipes;
  final Function(int index) onSelect;

  @override
  _SelectRecipeState createState() => _SelectRecipeState();
}

class _SelectRecipeState extends State<SelectRecipe> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Recipe',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 110,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onSelect(index);
                },
                child: MealBox(
                  imageUrl: widget.recipes[index]['imageUrl'],
                  name: widget.recipes[index]['name'],
                  description: widget.recipes[index]['description'],
                  isSelected: selectedIndex == index,
                ),
              );
            },
            itemCount: widget.recipes.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class SelectionBadge extends StatelessWidget {
  /// Constructs a [SelectionBadge] widget to show selected items.
  ///
  /// [child] is any [Widget] the badge is wrapping around.
  ///
  /// [showBadge] is a [bool] that controls the visibility of
  /// the badge.
  const SelectionBadge({
    Key key,
    this.showBadge = false,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Badge(
      borderSide: BorderSide(color: Colors.white, width: 2),
      position: BadgePosition(top: 0, end: -8),
      badgeColor: Theme.of(context).primaryColor,
      showBadge: showBadge,
      badgeContent: Icon(
        Icons.check,
        color: Colors.white,
        size: 12,
      ),
      child: child,
    );
  }
}

class MealBox extends StatelessWidget {
  const MealBox({
    Key key,
    @required this.imageUrl,
    @required this.name,
    this.isSelected = false,
    this.description = '',
  })  : assert(imageUrl != null),
        assert(name != null),
        super(key: key);

  final String imageUrl;
  final String name;
  final String description;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: SelectionBadge(
        showBadge: isSelected,
        child: Container(
          child: Stack(
            children: [
              MealBoxImage(imageUrl),
              Positioned(
                left: 6,
                bottom: 6,
                child: MealBoxTile(
                  title: name,
                  subtitle: description,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealBoxImage extends StatelessWidget {
  final String imageUrl;

  const MealBoxImage(this.imageUrl, {Key key})
      : assert(imageUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        height: 98,
        width: 106,
        fit: BoxFit.fill,
      ),
    );
  }
}

class MealBoxTile extends StatelessWidget {
  const MealBoxTile({
    Key key,
    @required this.title,
    this.subtitle = '',
  })  : assert(title != null),
        super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 65,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 26, 26, 0.58),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MealBoxText(
            title,
            fontSize: 7,
          ),
          SizedBox(height: 1),
          MealBoxText(
            subtitle,
            fontSize: 4,
          ),
        ],
      ),
    );
  }
}

class MealBoxText extends StatelessWidget {
  final String data;
  final double fontSize;

  const MealBoxText(
    this.data, {
    Key key,
    @required this.fontSize,
  })  : assert(data != null),
        assert(fontSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }
}
