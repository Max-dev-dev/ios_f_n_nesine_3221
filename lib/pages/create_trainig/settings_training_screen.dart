import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/training_cubit/training_cubit.dart';
import 'package:ios_f_n_nesine_3221/pages/create_trainig/saving_workout_screen.dart';

class SettingsTrainingScreen extends StatefulWidget {
  final String category;
  const SettingsTrainingScreen({required this.category, super.key});

  @override
  _SettingsTrainingScreenState createState() => _SettingsTrainingScreenState();
}

class _SettingsTrainingScreenState extends State<SettingsTrainingScreen> {
  int? selectedRepetitions;
  String? selectedExecutionTime;
  int? selectedApproaches;
  int? selectedRestTime;

  final List<int> repetitionsOptions = [1, 2, 3, 4, 5];
  final List<String> executionTimeOptions = [
    "15 sec",
    "30 sec",
    "45 sec",
    "60 sec",
    "1 min 15 sec",
    "1 min 30 sec",
    "1 min 45 sec",
    "2 min",
    "2 min 15 sec",
    "2 min 30 sec",
    "2 min 45 sec",
    "3 min",
    "3 min 15 sec",
    "3 min 30 sec",
    "3 min 45 sec",
    "4 min",
    "4 min 15 sec",
    "4 min 30 sec",
    "4 min 45 sec",
    "5 min",
  ];
  final List<int> approachesOptions = [2, 4, 6, 8];
  final List<int> restTimeOptions = [20, 30, 60];

  bool get isFormComplete =>
      selectedExecutionTime != null &&
      selectedApproaches != null &&
      selectedRestTime != null;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => TrainingCubit(),
      child: Scaffold(
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
          title: const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<TrainingCubit, TrainingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildDropdown(
                  //   "Number of repetitions",
                  //   'Select the number of repetitions',
                  //   repetitionsOptions.map((e) => "$e").toList(),
                  //   selectedRepetitions?.toString(),
                  //   (value) {
                  //     setState(
                  //       () => selectedRepetitions = int.tryParse(value!),
                  //     );
                  //   },
                  // ),
                  _buildDropdown(
                    "Execution time",
                    'Select the execution time',
                    executionTimeOptions,
                    selectedExecutionTime,
                    (value) {
                      setState(() => selectedExecutionTime = value);
                    },
                  ),
                  _buildSelectionGrid(
                    "Number of approaches",
                    approachesOptions,
                    selectedApproaches,
                    (value) {
                      setState(() => selectedApproaches = value);
                    },
                    screenHeight,
                  ),
                  _buildSelectionGrid(
                    "Rest time between sets",
                    restTimeOptions,
                    selectedRestTime,
                    (value) {
                      setState(() => selectedRestTime = value);
                    },
                    screenHeight,
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormComplete ? Colors.black : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          isFormComplete
                              ? () {
                                final training = Training(
                                  name: widget.category,
                                  category: widget.category,
                                  exerciseTime: _convertExecutionTime(
                                    selectedExecutionTime!,
                                  ),
                                  sets: selectedApproaches!,
                                  relaxTime: selectedRestTime!,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SavingWorkoutScreen(
                                          training: training,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String hintText,
    List<String> items,
    String? selectedItem,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedItem,
              hint: Text(hintText),
              items:
                  items.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSelectionGrid(
    String label,
    List<int> options,
    int? selectedValue,
    void Function(int) onTap,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              options.map((option) {
                return GestureDetector(
                  onTap: () => onTap(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth > 375 ? 24 : 20,
                      horizontal: screenWidth > 375 ? 30 : 25,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selectedValue == option
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$option${label.contains("time") ? " sec" : ""}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  int _convertExecutionTime(String time) {
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(time);
    if (matches.isNotEmpty) {
      return int.parse(matches.first.group(0)!);
    }
    return 30;
  }
}
