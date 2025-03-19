import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/training_cubit/training_cubit.dart';
import 'package:ios_f_n_nesine_3221/pages/home_page.dart';
import 'package:ios_f_n_nesine_3221/pages/home_screen.dart';

class SavingWorkoutScreen extends StatefulWidget {
  final Training training;

  const SavingWorkoutScreen({required this.training, super.key});

  @override
  _SavingWorkoutScreenState createState() => _SavingWorkoutScreenState();
}

class _SavingWorkoutScreenState extends State<SavingWorkoutScreen> {
  final List<String> titles = ["Cardio", "Stretching", "Yoga", "Own weight"];
  late TextEditingController workoutName = TextEditingController();

  @override
  void initState() {
    super.initState();
    workoutName = TextEditingController(text: widget.training.name);
  }

  @override
  Widget build(BuildContext context) {
    int categoryIndex = titles.indexOf(widget.training.category);
    String categoryIcon = 'assets/images/types_sport/${categoryIndex + 1}.png';

    return Scaffold(
      backgroundColor: const Color(0xFFD9A600),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A600),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/images/back_button.png',
              height: 50,
              width: 50,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'SAVING A WORKOUT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workout name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: workoutName,
                decoration: InputDecoration(
                  hintText: 'Enter the name of the workout',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.training.copyWith(name: value);
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(categoryIcon, height: 40, width: 40),
                    const SizedBox(width: 10),
                    Text(
                      widget.training.category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // _buildWorkoutInfo(
              //   'Number of repetitions',
              //   '${widget.training.sets}',
              // ),
              _buildWorkoutInfo(
                'Execution time',
                '${widget.training.exerciseTime} sec',
              ),
              _buildWorkoutInfo(
                'Number of approaches',
                '${widget.training.sets}',
              ),
              _buildWorkoutInfo(
                'Rest time between sets',
                '${widget.training.relaxTime} sec',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        workoutName.text.isNotEmpty ? Colors.black : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final newTraining = Training(
                      name: workoutName.text,
                      category: widget.training.category,
                      exerciseTime: widget.training.exerciseTime,
                      sets: widget.training.sets,
                      relaxTime: widget.training.relaxTime,
                    );
                    context.read<TrainingCubit>().addTraining(newTraining);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const HomeScreen(initialTabIndex: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Save workout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/gym_icon.png',
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutInfo(String label, String value) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
