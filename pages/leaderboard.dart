import 'package:flutter/material.dart';
import 'package:mobile/apis/auth_api.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  void getLeaderBoard() async {
    final response = await AuthApi.getLeaderboard();
    print(response.data);
  }

  @override
  void initState() {
    getLeaderBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
