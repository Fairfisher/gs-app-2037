import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_navigation.dart';
import '../services/workout_service.dart';
import '../services/meal_service.dart';
import '../widgets/workout_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/daily_summary_card.dart';
import '../models/workout.dart';
import '../models/meal.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(todayWorkoutsProvider);
    final meals = ref.watch(todayMealsProvider);
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FGitness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayWorkoutsProvider);
          ref.invalidate(todayMealsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEEE, MMMM d').format(now),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const DailySummaryCard(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workouts Today',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 28),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/add-workout');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              workouts.when(
                data: (List<Workout> data) {
                  if (data.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No workouts yet. Tap + to add one.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: data.map((Workout workout) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: WorkoutCard(
                          workout: workout,
                          onTap: () {
                            context.push('/workout/${workout.id}', extra: workout);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (Object error, StackTrace stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Error loading workouts',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meals Today',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 28),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/add-meal');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              meals.when(
                data: (List<Meal> data) {
                  if (data.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.restaurant,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No meals logged yet. Tap + to add one.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: data.map((Meal meal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MealCard(
                          meal: meal,
                          onTap: () {
                            context.push('/meal/${meal.id}', extra: meal);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (Object error, StackTrace stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Error loading meals',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
