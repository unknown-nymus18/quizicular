import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/apis/auth_api.dart';
import 'package:mobile/components/loading_screen.dart';
import 'package:mobile/pages/quiz.dart';
import 'package:mobile/pages/quiz_config.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final AnimationController _streakAnimationController;

  Future<dynamic> getData() async {
    try {
      final response = await AuthApi.isAuthenticated();
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _streakAnimationController = AnimationController(vsync: this);
    getLeaderBoard(); // Call leaderboard function
  }

  Future<void> getLeaderBoard() async {
    print("getLeaderBoard called");
    try {
      // Add your leaderboard API call here
    } catch (e) {
      print("Error in getLeaderBoard: $e");
    }
  }

  @override
  void dispose() {
    _streakAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    _buildWelcomeHeader(data),
                    SizedBox(height: 20),

                    // Daily Task Card
                    _buildDailyTaskCard(),
                    SizedBox(height: 20),

                    // Quick Actions
                    _buildQuickActions(),
                    SizedBox(height: 25),

                    // Featured Categories
                    _buildFeaturedCategories(),
                    SizedBox(height: 25),

                    // Recent Quiz Section
                    _buildRecentQuizzes(),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(color: Colors.white, child: LoadingScreen()),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(dynamic data) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome,",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  "${data['first_name']} ${data['last_name']}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Lottie.asset(
                    'assets/animations/Fire animation.json',
                    controller: _streakAnimationController,
                    onLoaded: (composition) {
                      _streakAnimationController
                        ..duration = composition.duration
                        ..repeat();
                    },
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "${data['profile']['streak']}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTaskCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.task_alt, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                "Daily Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "2/3 Completed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Complete 3 quizzes today to earn bonus points!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.67,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  "Create Quiz",
                  Icons.quiz,
                  Color(0xFF4CAF50),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizConfig()),
                    );
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  "Solo Mode",
                  Icons.person,
                  Color(0xFF2196F3),
                  () {},
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  "Multiplayer",
                  Icons.people,
                  Color(0xFFFF9800),
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCategories() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Featured Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryCard(
                  "Mathematics",
                  "120 Quizzes",
                  Color(0xFFE3F2FD),
                  Color(0xFF2196F3),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz(
                          difficulty: "medium",
                          topic: 'Mathematics',
                          questionsNumber: 10,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 15),
                _buildCategoryCard(
                  "Science",
                  "85 Quizzes",
                  Color(0xFFE8F5E8),
                  Color(0xFF4CAF50),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz(
                          difficulty: "medium",
                          topic: 'Science',
                          questionsNumber: 10,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 15),
                _buildCategoryCard(
                  "History",
                  "67 Quizzes",
                  Color(0xFFFFF3E0),
                  Color(0xFFFF9800),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz(
                          difficulty: "medium",
                          topic: 'History',
                          questionsNumber: 10,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 15),
                _buildCategoryCard(
                  "Literature",
                  "93 Quizzes",
                  Color(0xFFF3E5F5),
                  Color(0xFF9C27B0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz(
                          difficulty: "medium",
                          topic: 'Literature',
                          questionsNumber: 10,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    Color bgColor,
    Color accentColor,
    Function()? onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: 140,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.school, color: accentColor, size: 20),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentQuizzes() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Recent Quizzes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 15),
          _buildQuizItem(
            "Basic Algebra Quiz",
            "Mathematics",
            "85%",
            Color(0xFF2196F3),
          ),
          SizedBox(height: 12),
          _buildQuizItem("World War II", "History", "92%", Color(0xFFFF9800)),
          SizedBox(height: 12),
          _buildQuizItem(
            "Chemical Elements",
            "Science",
            "78%",
            Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizItem(
    String title,
    String subject,
    String score,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.quiz, color: color, size: 24),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subject,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
