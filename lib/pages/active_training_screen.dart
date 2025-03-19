// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/training_cubit/training_cubit.dart';
import 'package:ios_f_n_nesine_3221/pages/home_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class ActiveTrainingScreen extends StatefulWidget {
  final Training training;
  const ActiveTrainingScreen({required this.training, super.key});

  @override
  _ActiveTrainingScreenState createState() => _ActiveTrainingScreenState();
}

class _ActiveTrainingScreenState extends State<ActiveTrainingScreen> {
  Timer? _timer;
  int _timeLeft = 0;
  int _currentSet = 1;
  int _relaxCount = 0;
  bool _isPaused = true;
  bool _isWorkoutDone = false;
  bool _isRelaxTime = false;
  bool _isFirstStart = true;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.training.exerciseTime;
  }

  void _startPauseTimer() {
    if (_isPaused) {
      if (_isFirstStart) {
        _isFirstStart = false;
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            if (_currentSet < widget.training.sets) {
              if (_relaxCount < _currentSet) {
                _isRelaxTime = true;
                _timeLeft = widget.training.relaxTime;
                _relaxCount++;
              } else {
                _isRelaxTime = false;
                _currentSet++;
                _timeLeft = widget.training.exerciseTime;
              }
            } else {
              _timer?.cancel();
              _isWorkoutDone = true;
            }
          }
        });
      });
    } else {
      _timer?.cancel();
    }
    setState(() => _isPaused = !_isPaused);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0B800),
      body: _isWorkoutDone ? _buildWorkoutDoneScreen() : _buildTrainingScreen(),
    );
  }

  Widget _buildTrainingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0B800),
      appBar: AppBar(
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
        title: Text(
          widget.training.name,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 8.0,
                      percent:
                          !_isRelaxTime
                              ? ((_timeLeft / widget.training.exerciseTime).clamp(
                                0.0,
                                1.0,
                              ))
                              : ((_timeLeft / widget.training.relaxTime).clamp(
                                0.0,
                                1.0,
                              )),
                      center: Text(
                        _formatTime(_timeLeft),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      progressColor: const Color(0xFFE8B700),
                      backgroundColor: const Color(0xFF6A5300),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isRelaxTime ? "RELAX" : "DO THE EXERCISE",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Exercise:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          _getCategoryIcon(widget.training.category),
                          const SizedBox(width: 4.0),
                          Text(
                            widget.training.category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildProgressInfo(
                "EXECUTION PROGRESS",
                _currentSet,
                widget.training.sets,
              ),
              _buildProgressInfo(
                "NUMBER OF RELAXATIONS",
                _relaxCount,
                widget.training.sets,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 220,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _startPauseTimer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isFirstStart)
                        const Icon(Icons.pause, color: Colors.white, size: 30),
                      if (!_isFirstStart) const SizedBox(width: 8.0),
                      Text(
                        _isFirstStart
                            ? "START"
                            : (_isPaused ? "CONTINUE" : "PAUSE"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildProgressInfo(String label, int current, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            CircularPercentIndicator(
              radius: 25.0,
              lineWidth: 5.0,
              percent: (current / total).clamp(0.0, 1.0),
              center: Text(
                "$current/$total",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              progressColor: const Color(0xFFE8B700),
              backgroundColor: const Color(0xFF6A5300),
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDoneScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0B800),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Finish',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        'assets/images/ok_icon.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'WORKOUT DONE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.training.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RESULTS:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL WORKOUT TIME',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE8B700),
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${widget.training.exerciseTime * widget.training.sets ~/ 60} min',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'COMPLETED APPROACHES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE8B700),
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${widget.training.sets} set',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'EXERCISE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              _getCategoryIcon(widget.training.category),
                              const SizedBox(width: 5),
                              Text(
                                widget.training.category,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    String formattedDate = DateFormat(
                      'dd.MM.yyyy',
                    ).format(DateTime.now());
        
                    context.read<TrainingCubit>().updateTraining(
                      widget.training.name,
                      widget.training.copyWith(lastTraining: formattedDate),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const HomeScreen(initialTabIndex: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Complete the workout',
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
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case "Cardio":
        return Image.asset(
          'assets/images/types_sport/1.png',
          width: 40,
          height: 40,
        );
      case "Stretching":
        return Image.asset(
          'assets/images/types_sport/2.png',
          width: 40,
          height: 40,
        );
      case "Yoga":
        return Image.asset(
          'assets/images/types_sport/3.png',
          width: 40,
          height: 40,
        );
      case "Own weight":
        return Image.asset(
          'assets/images/types_sport/4.png',
          width: 40,
          height: 40,
        );
      default:
        return Image.asset(
          'assets/images/types_sport/1.png',
          width: 40,
          height: 40,
        );
    }
  }

  String _formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }
}
