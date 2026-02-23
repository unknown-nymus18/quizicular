import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/apis/auth_api.dart';
import 'package:mobile/components/loading_screen.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/pages/profile.dart';
import 'package:mobile/pages/quiz_config.dart';
import 'package:mobile/pages/search.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    Home(),
    Search(),
    QuizConfig(),
    Leaderboard(),
    Profile(),
  ];

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Navigation items
          Row(
            children: [
              // Home icon
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      Icons.home,
                      color: _selectedIndex == 0
                          ? Color(0xFF4CAF50)
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
              // Search icon
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      Icons.search,
                      color: _selectedIndex == 1
                          ? Color(0xFF4CAF50)
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
              // Center spacing for FAB
              Expanded(child: SizedBox()),
              // Leaderboard icon
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 3),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      Icons.leaderboard,
                      color: _selectedIndex == 3
                          ? Color(0xFF4CAF50)
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
              // Profile icon
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      Icons.person,
                      color: _selectedIndex == 4
                          ? Color(0xFF4CAF50)
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Centered FAB
          Positioned(
            top: 10,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizConfig()),
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildCustomBottomNavBar(),
      body: SafeArea(child: pages[_selectedIndex]),
    );
  }
}
