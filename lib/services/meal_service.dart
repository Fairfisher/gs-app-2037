import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import 'storage_service.dart';

final mealServiceProvider = Provider<MealService>((ref) {
  return MealService(ref.watch(storageServiceProvider));
});

final allMealsProvider = FutureProvider<List<Meal>>((ref) async {
  return ref.watch(mealServiceProvider).getMeals();
});

final todayMealsProvider = FutureProvider<List<Meal>>((ref) async {
  return ref.watch(mealServiceProvider).getTodayMeals();
});

final mealStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(mealServiceProvider).getWeeklyStats();
});

class MealService {
  final StorageService _storage;
  static const String _storageKey = 'meals';

  MealService(this._storage);

  Future<List<Meal>> getMeals() async {
    final jsonList = _storage.getJsonList(_storageKey);
    if (jsonList == null) return <Meal>[];
    return jsonList.map((Map<String, dynamic> json) => Meal.fromJson(json)).toList();
  }

  Future<List<Meal>> getTodayMeals() async {
    final allMeals = await getMeals();
    final now = DateTime.now();
    return allMeals.where((Meal meal) {
      return meal.date.year == now.year &&
          meal.date.month == now.month &&
          meal.date.day == now.day;
    }).toList();
  }

  Future<void> addMeal(Meal meal) async {
    final meals = await getMeals();
    meals.add(meal);
    await _saveMeals(meals);
  }

  Future<void> updateMeal(Meal meal) async {
    final meals = await getMeals();
    final index = meals.indexWhere((Meal m) => m.id == meal.id);
    if (index != -1) {
      meals[index] = meal;
      await _saveMeals(meals);
    }
  }

  Future<void> deleteMeal(String id) async {
    final meals = await getMeals();
    meals.removeWhere((Meal m) => m.id == id);
    await _saveMeals(meals);
  }

  Future<Map<String, dynamic>> getWeeklyStats() async {
    final meals = await getMeals();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final weekMeals = meals.where((Meal meal) {
      return meal.date.isAfter(weekAgo);
    }).toList();

    final totalMeals = weekMeals.length;
    final totalCalories = weekMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.calories,
    );
    final totalProtein = weekMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.protein,
    );
    final totalCarbs = weekMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.carbs,
    );
    final totalFat = weekMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.fat,
    );

    return <String, dynamic>{
      'totalMeals': totalMeals,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'avgCalories': totalMeals > 0 ? (totalCalories / totalMeals).round() : 0,
    };
  }

  Future<void> _saveMeals(List<Meal> meals) async {
    final jsonList = meals.map((Meal m) => m.toJson()).toList();
    await _storage.saveJsonList(_storageKey, jsonList);
  }
}
