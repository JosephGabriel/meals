import 'package:flutter/material.dart';
import 'package:meals/data/dummy.dart';
import 'package:meals/models/settings.dart';

import 'package:meals/screens/category_meals.dart';
import 'package:meals/screens/meal_detail.dart';
import 'package:meals/screens/settings.dart';
import 'package:meals/screens/tabs.dart';

import 'package:meals/models/meal.dart';

import 'package:meals/utils/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingsModel settings = SettingsModel();

  List<Meal> _avaliableMeals = dummyMeals;
  final List<Meal> _favoriteMeals = [];

  void _filterMeals(SettingsModel settings) {
    setState(() {
      this.settings = settings;

      _avaliableMeals = dummyMeals.where((meal) {
        final filterGlutten = settings.isGlutterFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;

        return !filterGlutten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        fontFamily: 'Raleway',
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      routes: {
        AppRoutes.home: (ctx) => TabsScreen(favoriteMeals: _favoriteMeals),
        AppRoutes.categoriesMeals: (ctx) =>
            CategoriesMealsScreen(meals: _avaliableMeals),
        AppRoutes.mealsDetails: (ctx) => MealDetailScreen(
            onToggleFavorite: _toggleFavorite, isFavorite: _isFavorite),
        AppRoutes.settings: (ctx) =>
            SettingsScreen(onSettingsChanged: _filterMeals, settings: settings),
      },
    );
  }
}
