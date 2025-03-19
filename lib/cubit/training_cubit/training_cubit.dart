import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingCubit extends Cubit<TrainingState> {
  final Logger _logger = Logger();

  TrainingCubit() : super(TrainingLoaded([])) {
    _loadTrainings();
  }

  Future<void> _loadTrainings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedTrainings = prefs.getString('trainings');
    if (storedTrainings != null) {
      final List<dynamic> decodedList = jsonDecode(storedTrainings);
      final trainings = decodedList.map((e) => Training.fromJson(e)).toList();
      emit(TrainingLoaded(trainings));
    }
  }

  Future<void> _saveTrainings(List<Training> trainings) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(trainings.map((e) => e.toJson()).toList());
    await prefs.setString('trainings', encodedList);
  }

  void addTraining(Training training) {
    if (state is TrainingLoaded) {
      final trainings = List<Training>.from((state as TrainingLoaded).trainings)..add(training);
      emit(TrainingLoaded(trainings));
      _saveTrainings(trainings);
    } else {
      emit(TrainingLoaded([training]));
      _saveTrainings([training]);
    }
    _logger.i("Нова програма тренувань додана: \${training.name}");
  }

  void updateTraining(String name, Training updatedTraining) {
    if (state is TrainingLoaded) {
      final trainings = (state as TrainingLoaded).trainings.map((t) {
        return t.name == name ? updatedTraining : t;
      }).toList();
      emit(TrainingLoaded(trainings));
      _saveTrainings(trainings);
      _logger.i("Оновлено тренування: \${updatedTraining.name}");
    }
  }

  void removeTraining(String name) {
    if (state is TrainingLoaded) {
      final trainings = (state as TrainingLoaded).trainings.where((t) => t.name != name).toList();
      emit(TrainingLoaded(trainings));
      _saveTrainings(trainings);
      _logger.i("Видалено тренування: $name");
    }
  }
}

abstract class TrainingState extends Equatable {
  const TrainingState();

  @override
  List<Object?> get props => [];
}

class TrainingLoaded extends TrainingState {
  final List<Training> trainings;

  const TrainingLoaded(this.trainings);

  @override
  List<Object?> get props => [trainings];
}

class Training {
  final String name;
  final String category;
  final int exerciseTime;
  final int sets;
  final int relaxTime;
  final String? lastTraining;

  Training({
    required this.name,
    required this.category,
    required this.exerciseTime,
    required this.sets,
    required this.relaxTime,
    this.lastTraining,
  });

  Training copyWith({
    String? name,
    String? category,
    int? exerciseTime,
    int? sets,
    int? relaxTime,
    String? lastTraining,
  }) {
    return Training(
      name: name ?? this.name,
      category: category ?? this.category,
      exerciseTime: exerciseTime ?? this.exerciseTime,
      sets: sets ?? this.sets,
      relaxTime: relaxTime ?? this.relaxTime,
      lastTraining: lastTraining ?? this.lastTraining,
    );
  }

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      name: json['name'],
      category: json['category'],
      exerciseTime: json['exerciseTime'],
      sets: json['sets'],
      relaxTime: json['relaxTime'],
      lastTraining: json['lastTraining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'exerciseTime': exerciseTime,
      'sets': sets,
      'relaxTime': relaxTime,
      'lastTraining': lastTraining,
    };
  }
}