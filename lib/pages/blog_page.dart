import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/blog_cubit/blog_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A600),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A600),
        elevation: 0,
        title: const Text(
          'BLOG',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('TIPS', 0),
                const SizedBox(width: 16),
                _buildTabButton('ARTICLES', 1),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            height: 1,
            color: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlogListScreen(category: 'Tips'),
                BlogListScreen(category: 'Articles'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => setState(() => _tabController.index = index),
      child: Container(
        alignment: Alignment.center,
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class BlogListScreen extends StatelessWidget {
  final String category;
  BlogListScreen({super.key, required this.category});

  final Map<String, List<Map<String, String>>> content = {
    'Tips': [
      {
        'id': "1",
        'title': 'The importance of a healthy lifestyle and physical activity',
        'description':
            'Regular exercise and a balanced diet are key components of a healthy lifestyle.',
        'details': '''Thanks to this, you will receive:
- Reduced risk of heart and vascular diseases.
- Improved lung function and increased energy levels.
- Improved stress resistance and improved psychological state.
- Increased metabolism and weight loss.
- Improved sleep quality and skin appearance.''',
      },
      {
        'id': "2",
        'title': 'Make your workout more interesting',
        'description':
            'Use multimedia, set reminders, share achievements, and set specific goals to stay motivated in your workouts.',
        'details':
            '''- Multimedia support. Exercise while watching your favorite show, listening to a podcast or audiobook.
- Reminders. Set them on your smartphone to regularly remind yourself to exercise.
- Share achievements. Communicate with family and friends about your workouts.
- Specific goals. Set specific goals that you want to achieve through training.''',
      },
      {
        'id': "3",
        'title': 'When is the best time to exercise?',
        'description':
            'Morning and evening workouts have benefits, but the most important thing is to choose a time that fits your schedule and keeps you consistent.',
        'details':
            '''Ideally, it’s in the morning or in the evening, a few hours before bed. However, in general, time does not affect the result so much, the main thing is that you are comfortable.''',
      },
      {
        'id': "4",
        'title': 'How to increase the intensity of basic exercises?',
        'description':
            'Increase repetitions for endurance, add weight for muscle growth, and tailor intensity to your goals.',
        'details': '''There are several methods to increase intensity:
- Increasing the number of repetitions improves endurance.
- Using additional weight accelerates muscle growth.
- Tailor intensity based on your personal goals.''',
      },
    ],
    'Articles': [
      {
        'id': "1",
        'title': 'Fitness training program for beginners',
        'description':
            'To achieve the desired result, you will need 2-3 months. Start with basic exercises, gradually increase load, and always warm up and stretch.',
        'details': '''General recommendations:
- Graduation. Increase the load gradually to avoid injuries.
- Warm-up before training: cardio, stretching elements.
- Start with basic exercises: squats, deadlifts, lunges.
- Perform exercises 10-15 times in 2-4 sets.
- Breathe correctly: inhale when lifting, exhale when lowering.
- Always end your workout with stretching.''',
      },
      {
        'id': "2",
        'title': '4 simple tips: how to motivate yourself to train',
        'description':
            'Set ambitious goals, create a routine, vary your workouts, and team up with friends to stay motivated.',
        'details':
            '''1. Set ambitious goals: Goals give you something to work towards and keep you motivated.
2. Create a routine: Develop self-discipline with structured workouts.
3. Vary your exercise: Change workouts to keep them interesting.
4. Team up with friends: A workout buddy helps maintain accountability.''',
      },
      {
        'id': "3",
        'title': 'How much exercise should you do?',
        'description':
            'Experts recommend at least 150 minutes of moderate aerobic exercise per week, which can be split into smaller sessions.',
        'details':
            '''The American College of Sports Medicine recommends at least 150 minutes of moderate aerobic exercise per week.
You can divide it however you want:
- 30 minutes five times a week
- 35–40 minutes every other day.''',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: content[category]!.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            bottom: index == content[category]!.length - 1 ? 135 : 10,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content[category]![index]['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 200, height: 1, color: Colors.black),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 240,
                    child: Text(
                      content[category]![index]['description']!,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      maxLines: 4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlogDetailScreen(
                                id: content[category]![index]['id']!,
                                category: category,
                                title: content[category]![index]['title']!,
                                description:
                                    content[category]![index]['description']!,
                                details: content[category]![index]['details']!,
                              ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/blog_button.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class BlogDetailScreen extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String description;
  final String details;
  final String url = 'https://ligafitness.com.ua';

  const BlogDetailScreen({
    required this.id,
    required this.category,
    required this.description,
    required this.title,
    required this.details,
    super.key,
  });

  void _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareContent() {
    final String shareText =
        "📣 Hey friends, I found an interesting blog for you! \n\n' '📌 *$title* \n\n$description \n\n''Read more here: $url";
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A600),
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
        title: const Text(
          'BLOG',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 26.0),
            Center(
              child: GestureDetector(
                onTap: _launchURL,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 285.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'For detailed information,\nvisit the ligafitness.com.ua',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.link,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _shareContent,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          BlocBuilder<FavoritesCubit, FavoritesState>(
                            builder: (context, state) {
                              final isFav = context
                                  .read<FavoritesCubit>()
                                  .isFavorite(id, category);

                              return GestureDetector(
                                onTap:
                                    () => context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(id, category),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isFav
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(width: 240, height: 1, color: Colors.black),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
