import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/apis/auth_api.dart';
import 'package:mobile/components/loading_screen.dart';
import 'package:mobile/pages/quiz_config.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _streakAnimationController;

  Future<dynamic> getData() async {
    try {
      final response = await AuthApi.isAuthenticated();
      if (response.statusCode == 200) {
        // print(response.data);
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
  }

  @override
  void dispose() {
    super.dispose();
    _streakAnimationController.dispose();
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
              return Center(
                child: Column(
                  children: [
                    Container(
                      // decoration: BoxDecoration(),
                      // color: Colors.red,
                      margin: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 15,
                            children: [
                              CircleAvatar(),
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Welcome,"),
                                  Text(
                                    "${data['first_name']} ${data['last_name']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(255, 230, 149, 143),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 5,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Lottie.asset(
                                    'assets/animations/Fire animation.json',
                                    controller: _streakAnimationController,
                                    onLoaded: (composition) {
                                      _streakAnimationController
                                        ..duration = composition.duration
                                        ..forward();
                                    },
                                  ),
                                ),
                                Text(
                                  "${data['profile']['streak']}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 3, // 3 columns
                      shrinkWrap: true, // Important if inside ScrollView
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 7,
                      ),
                      crossAxisSpacing: 7,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizConfig(),
                                ),
                              );
                            },
                            child: Center(child: Text('Create Quiz')),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text('Item 2')),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text('Item 3')),
                        ),
                      ],
                    ),
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
}
