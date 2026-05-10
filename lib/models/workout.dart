import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String id;
  final String name;
  final String type;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime date;
  final String notes;

  const Workout({
    required this.id,
    required this.name,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, type, durationMinutes, caloriesBurned, date, notes];
}
