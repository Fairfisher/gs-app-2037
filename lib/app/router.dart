import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/activity_page.dart';
import '../pages/stats_page.dart';
import '../pages/profile_page.dart';
import '../pages/workout_detail_page.dart';
import '../pages/meal_detail_page.dart';
import '../pages/add_workout_page.dart';
import '../pages/add_meal_page.dart';
import '../pages/settings_page.dart';
import '../models/workout.dart';
import '../models/meal.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/activity',
        name: 'activity',
        builder: (BuildContext context, GoRouterState state) {
          return const ActivityPage();
        },
      ),
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (BuildContext context, GoRouterState state) {
          return const StatsPage();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '/workout/:id',
        name: 'workout-detail',
        builder: (BuildContext context, GoRouterState state) {
          final workout = state.extra as Workout;
          return WorkoutDetailPage(workout: workout);
        },
      ),
      GoRoute(
        path: '/meal/:id',
        name: 'meal-detail',
        builder: (BuildContext context, GoRouterState state) {
          final meal = state.extra as Meal;
          return MealDetailPage(meal: meal);
        },
      ),
      GoRoute(
        path: '/add-workout',
        name: 'add-workout',
        builder: (BuildContext context, GoRouterState state) {
          return const AddWorkoutPage();
        },
      ),
      GoRoute(
        path: '/add-meal',
        name: 'add-meal',
        builder: (BuildContext context, GoRouterState state) {
          return const AddMealPage();
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsPage();
        },
      ),
    ],
  );
});
