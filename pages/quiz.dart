import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/apis/quiz_api.dart';
import 'package:mobile/components/loading_screen.dart';

// ignore: must_be_immutable
class Quiz extends StatefulWidget {
  String topic;
  String difficulty;
  int questionsNumber;
  Quiz({
    super.key,
    required this.difficulty,
    required this.topic,
    required this.questionsNumber,
  });

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  PageController _pageController = PageController();

  int currentIndex = 0;
  Future getQuiz() async {
    // final response = await QuizApi.getQuiz(
    //   widget.topic,
    //   widget.difficulty,
    //   widget.questionsNumber,
    // );
    // if (response.statusCode == 200) {
    //   return response.data;
    // }
    Map<String, dynamic> data = {
      "status": "success",
      "topic": "algebra",
      "difficulty": "easy",
      "ai_generated_quiz": [
        {
          "question": "Solve for x: 2x + 3 = 7.",
          "choices": [1, 2, 3, 4],
          "answer_index": 1,
        },
        {
          "question": "Simplify the expression: 5a - 2a.",
          "choices": ["3a", "7a", "2a", "5a"], // Added missing choices
          "answer_index": 0,
        },
        {
          "question": "What is the value of x in the equation x² = 9?",
          "choices": [3, -3, "Both 3 and -3", 0],
          "answer_index": 2,
        },
        {
          "question": "If y = 4, what is the result of the expression 3y + 2?",
          "choices": [10, 14, 12, 16],
          "answer_index": 1,
        },
        {
          "question":
              "Which of the following is the solution set for the inequality 2x - 5 < 1?",
          "choices": ["x < 2", "x > 2", "x < 3", "x > 3"],
          "answer_index": 2,
        },
      ],
    };

    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget questionCard(String question, List<dynamic> choices, int answerIndex) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceDim,
      ),
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50),
          ...List.generate(choices.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: BoxBorder.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(15),
              child: Text(
                "${index + 1}) ${choices[index]}",
                style: TextStyle(fontSize: 16),
              ),
            );
          }),
        ],
      ),
    );
  }

  void next() {
    currentIndex++;
    _pageController.animateToPage(
      currentIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: getQuiz(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingScreen());
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              // print(data);
              List ai_quiz = snapshot.data['ai_generated_quiz'];
              return Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(37, 6, 85, 1),
                          ),
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      itemCount: ai_quiz.length,
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return questionCard(
                          ai_quiz[index]['question'],
                          ai_quiz[index]['choices'],
                          ai_quiz[index]['answer_index'],
                        );
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    child: MaterialButton(
                      elevation: 10,
                      onPressed: () => next(),
                      minWidth: 150,
                      height: 50,
                      color: Color.fromRGBO(138, 231, 140, 1),
                      child: Text("Next"),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
