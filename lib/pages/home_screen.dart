import 'package:flutter/material.dart';
import 'package:ios_f_n_nesine_3221/pages/blog_page.dart';
import 'package:ios_f_n_nesine_3221/pages/home_page.dart';
import 'package:ios_f_n_nesine_3221/pages/register_screen.dart';
import 'package:ios_f_n_nesine_3221/pages/saved_blog_page.dart';
import 'package:ios_f_n_nesine_3221/pages/trainings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    _checkRegistration();
    selectedIndex = widget.initialTabIndex;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const BlogPage(),
    const TrainingsScreen(),
    const SavedBlogPage(),
  ];

  Future<void> _checkRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null || username.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[selectedIndex],
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(0, 'assets/images/icons/home.png'),
                  _buildTabItem(1, 'assets/images/icons/blog.png'),
                  _buildTabItem(2, 'assets/images/icons/gym.png'),
                  _buildTabItem(3, 'assets/images/icons/group.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          iconPath,
          height: 30,
          width: 30,
          color: selectedIndex == index ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
