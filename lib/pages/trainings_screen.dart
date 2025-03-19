// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/training_cubit/training_cubit.dart';
import 'package:ios_f_n_nesine_3221/pages/active_training_screen.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class TrainingsScreen extends StatefulWidget {
  const TrainingsScreen({super.key});

  @override
  _TrainingsScreenState createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  final DateTime today = DateTime.now();

  void _showDeleteTrainingDialog(BuildContext context, String trainingName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFFF0B800),
            title: const Text(
              "Remove Training",
              style: TextStyle(fontSize: 24.0),
            ),
            content: const Text(
              "Are you sure you want to delete your training?",
              style: TextStyle(fontSize: 16.0),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<TrainingCubit>().removeTraining(trainingName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "Your training has been deleted successfully",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF0B800),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF0B800),
        elevation: 0,
        title: const Text(
          'MY WORKOUTS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TrainingCubit, TrainingState>(
        builder: (context, state) {
          if (state is TrainingLoaded && state.trainings.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: state.trainings.length,
              itemBuilder: (context, index) {
                final training = state.trainings[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == state.trainings.length - 1 ? 135 : 10,
                  ),
                  child: _buildWorkoutCard(training, screenWidth),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No workouts available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildWorkoutCard(Training training, double screenWidth) {
    Logger().i(
      'Name: ${training.name},${training.lastTraining}, and today: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
    );

    return GestureDetector(
      onTap: () {
        if (training.lastTraining == null ||
            training.lastTraining !=
                DateFormat('dd.MM.yyyy').format(DateTime.now()))
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActiveTrainingScreen(training: training),
            ),
          );
      },
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  training.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(width: 240, height: 1, color: Colors.black),
                const SizedBox(height: 10),
                SizedBox(
                  width: 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _getCategoryIcon(training.category),
                          Text(
                            training.category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed:
                            () => _showDeleteTrainingDialog(
                              context,
                              training.name,
                            ),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (training.lastTraining ==
                DateFormat('dd.MM.yyyy').format(DateTime.now()))
              GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  width: screenWidth > 375 ? 70 : 60,
                  height: screenWidth > 375 ? 70 : 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0B800),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/ok_icon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  width: screenWidth > 375 ? 70 : 60,
                  height: screenWidth > 375 ? 70 : 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0B800),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/rocket_icon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

    Widget _getCategoryIcon(String category) {
    switch (category) {
      case "Cardio":
        return Image.asset(
          'assets/images/types_sport/1.png',
          width: 25,
          height: 25,
        );
      case "Stretching":
        return Image.asset(
          'assets/images/types_sport/2.png',
          width: 25,
          height: 25,
        );
      case "Yoga":
        return Image.asset(
          'assets/images/types_sport/3.png',
          width: 25,
          height: 25,
        );
      case "Own weight":
        return Image.asset(
          'assets/images/types_sport/4.png',
          width: 25,
          height:25,
        );
      default:
        return Image.asset(
          'assets/images/types_sport/1.png',
          width: 25,
          height: 25,
        );
    }
  }
}
