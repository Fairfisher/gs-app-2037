import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/workout_service.dart';
import '../services/meal_service.dart';
import '../models/workout.dart';
import '../models/meal.dart';

class StatsChartCard extends ConsumerWidget {
  const StatsChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(allWorkoutsProvider);
    final meals = ref.watch(allMealsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: workouts.when(
                data: (List<Workout> workoutData) {
                  return meals.when(
                    data: (List<Meal> mealData) {
                      final chartData = _prepareChartData(workoutData, mealData);
                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _getMaxY(chartData),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => Theme.of(context).colorScheme.surfaceContainerHighest,
                              tooltipPadding: const EdgeInsets.all(8),
                              tooltipMargin: 8,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const List<String> days = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  return Text(
                                    days[value.toInt()],
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: chartData,
                          gridData: const FlGridData(show: false),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('Error loading data')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading data')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _prepareChartData(List<Workout> workouts, List<Meal> meals) {
    final now = DateTime.now();
    final List<int> weekData = List<int>.filled(7, 0);

    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final dayWorkouts = workouts.where((Workout w) {
        return w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day;
      });
      final dayMeals = meals.where((Meal m) {
        return m.date.year == date.year &&
            m.date.month == date.month &&
            m.date.day == date.day;
      });
      weekData[i] = dayWorkouts.length + dayMeals.length;
    }

    return List<BarChartGroupData>.generate(
      7,
      (int index) => BarChartGroupData(
        x: index,
        barRods: <BarChartRodData>[
          BarChartRodData(
            toY: weekData[index].toDouble(),
            color: const Color(0xFF4A90E2),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<BarChartGroupData> data) {
    if (data.isEmpty) return 10;
    final maxValue = data.map((BarChartGroupData group) => group.barRods[0].toY).reduce((double a, double b) => a > b ? a : b);
    return maxValue + 2;
  }
}
