import '../widgets/meal_planner/eattly_calendar.dart';
import 'package:flutter/material.dart';

import './create_meal_plan_screen.dart';
import '../widgets/core/action_icon_button.dart';
import '../widgets/core/app_bar_icon_button.dart';
import '../widgets/core/eattly_app_bar.dart';
import '../widgets/core/eattly_drawer.dart';

class MealPlannerScreen extends StatelessWidget {
  static const String routeName = '/meal-planner';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: EattlyAppBar(
        title: 'Meal Planner',
        leading: AppBarIconButton(
          icon: Icons.bar_chart_rounded,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [
          ActionIconButton(
            icon: Icons.add,
            onPressed: () {
              Navigator.of(context).pushNamed(CreateMealPlanScreen.routeName);
            },
          ),
        ],
      ),
      drawer: EattlyDrawer(),
      body: EattlyCalendar(),
    );
  }
}
