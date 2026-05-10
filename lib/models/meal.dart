import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final String mealType;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime date;
  final String notes;

  const Meal({
    required this.id,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      mealType: json['mealType'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fat: json['fat'] as int,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, mealType, calories, protein, carbs, fat, date, notes];
}
