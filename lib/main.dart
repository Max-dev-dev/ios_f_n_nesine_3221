import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/blog_cubit/blog_cubit.dart';
import 'package:ios_f_n_nesine_3221/cubit/registed_cubit/register_cubit.dart';
import 'package:ios_f_n_nesine_3221/cubit/training_cubit/training_cubit.dart';
import 'dart:async';

import 'package:ios_f_n_nesine_3221/pages/home_screen.dart';
import 'package:ios_f_n_nesine_3221/pages/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegistrationCubit()..loadProfile()),
        BlocProvider(create: (_) => FavoritesCubit()..loadFavorites()),
        BlocProvider(create: (_) => TrainingCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          scaffoldBackgroundColor: const Color(0xFFE8B700),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('first_run') ?? true;

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  isFirstRun ? const OnboardingScreen() : const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/default_background.png',
            fit: BoxFit.cover,
          ),
        ),
        const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CustomLoader()),
        ),
      ],
    );
  }
}

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key});

  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _widthAnimation = Tween<double>(
      begin: 1,
      end: 73,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.greenAccent,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 30,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            right: -4,
            top: 3,
            child: Container(
              width: 4,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: 3,
            top: 3,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: _widthAnimation.value,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
