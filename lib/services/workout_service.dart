import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import 'storage_service.dart';

final workoutServiceProvider = Provider<WorkoutService>((ref) {
  return WorkoutService(ref.watch(storageServiceProvider));
});

final allWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  return ref.watch(workoutServiceProvider).getWorkouts();
});

final todayWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  return ref.watch(workoutServiceProvider).getTodayWorkouts();
});

final workoutStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(workoutServiceProvider).getWeeklyStats();
});

class WorkoutService {
  final StorageService _storage;
  static const String _storageKey = 'workouts';

  WorkoutService(this._storage);

  Future<List<Workout>> getWorkouts() async {
    final jsonList = _storage.getJsonList(_storageKey);
    if (jsonList == null) return <Workout>[];
    return jsonList.map((Map<String, dynamic> json) => Workout.fromJson(json)).toList();
  }

  Future<List<Workout>> getTodayWorkouts() async {
    final allWorkouts = await getWorkouts();
    final now = DateTime.now();
    return allWorkouts.where((Workout workout) {
      return workout.date.year == now.year &&
          workout.date.month == now.month &&
          workout.date.day == now.day;
    }).toList();
  }

  Future<void> addWorkout(Workout workout) async {
    final workouts = await getWorkouts();
    workouts.add(workout);
    await _saveWorkouts(workouts);
  }

  Future<void> updateWorkout(Workout workout) async {
    final workouts = await getWorkouts();
    final index = workouts.indexWhere((Workout w) => w.id == workout.id);
    if (index != -1) {
      workouts[index] = workout;
      await _saveWorkouts(workouts);
    }
  }

  Future<void> deleteWorkout(String id) async {
    final workouts = await getWorkouts();
    workouts.removeWhere((Workout w) => w.id == id);
    await _saveWorkouts(workouts);
  }

  Future<Map<String, dynamic>> getWeeklyStats() async {
    final workouts = await getWorkouts();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final weekWorkouts = workouts.where((Workout workout) {
      return workout.date.isAfter(weekAgo);
    }).toList();

    final totalWorkouts = weekWorkouts.length;
    final totalDuration = weekWorkouts.fold<int>(
      0,
      (int sum, Workout workout) => sum + workout.durationMinutes,
    );
    final totalCalories = weekWorkouts.fold<int>(
      0,
      (int sum, Workout workout) => sum + workout.caloriesBurned,
    );

    return <String, dynamic>{
      'totalWorkouts': totalWorkouts,
      'totalDuration': totalDuration,
      'totalCalories': totalCalories,
      'avgDuration': totalWorkouts > 0 ? (totalDuration / totalWorkouts).round() : 0,
    };
  }

  Future<void> _saveWorkouts(List<Workout> workouts) async {
    final jsonList = workouts.map((Workout w) => w.toJson()).toList();
    await _storage.saveJsonList(_storageKey, jsonList);
  }
}
