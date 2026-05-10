import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/workout_service.dart';
import '../services/meal_service.dart';
import '../services/user_service.dart';
import '../models/meal.dart';

class DailySummaryCard extends ConsumerWidget {
  const DailySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWorkouts = ref.watch(todayWorkoutsProvider);
    final todayMeals = ref.watch(todayMealsProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Workouts',
                    todayWorkouts.when(
                      data: (data) => data.length.toString(),
                      loading: () => '-',
                      error: (_, __) => '0',
                    ),
                    Icons.fitness_center,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Meals',
                    todayMeals.when(
                      data: (data) => data.length.toString(),
                      loading: () => '-',
                      error: (_, __) => '0',
                    ),
                    Icons.restaurant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calories Consumed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      todayMeals.when(
                        data: (data) {
                          final total = data.fold<int>(
                            0,
                            (int sum, Meal meal) => sum + meal.calories,
                          );
                          return Text(
                            '$total kcal',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('0 kcal'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calories Burned',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      todayWorkouts.when(
                        data: (data) {
                          final total = data.fold<int>(
                            0,
                            (sum, workout) => sum + workout.caloriesBurned,
                          );
                          return Text(
                            '$total kcal',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('0 kcal'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            userProfile.when(
              data: (profile) {
                final goal = profile['calorieGoal'] as int;
                final consumed = todayMeals.when(
                  data: (data) => data.fold<int>(0, (int sum, Meal meal) => sum + meal.calories),
                  loading: () => 0,
                  error: (_, __) => 0,
                );
                final progress = consumed / goal;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Goal Progress',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress > 1 ? 1 : progress,
                        minHeight: 8,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
