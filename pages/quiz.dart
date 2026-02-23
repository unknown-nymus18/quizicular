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
  ValueNotifier<int?> selectedAnswerNotifier = ValueNotifier<int?>(null);

  int currentIndex = 0;
  Future getQuiz() async {
    final response = await QuizApi.getQuiz(
      widget.topic,
      widget.difficulty,
      widget.questionsNumber,
    );
    if (response.statusCode == 200) {
      return response.data;
    }
    // Map<String, dynamic> data = {
    //   "status": "success",
    //   "topic": "algebra",
    //   "difficulty": "easy",
    //   "ai_generated_quiz": [
    //     {
    //       "question": "Solve for x: 2x + 3 = 7.",
    //       "choices": [1, 2, 3, 4],
    //       "answer_index": 1,
    //     },
    //     {
    //       "question": "Simplify the expression: 5a - 2a.",
    //       "choices": ["3a", "7a", "2a", "5a"], // Added missing choices
    //       "answer_index": 0,
    //     },
    //     {
    //       "question": "What is the value of x in the equation x² = 9?",
    //       "choices": [3, -3, "Both 3 and -3", 0],
    //       "answer_index": 2,
    //     },
    //     {
    //       "question": "If y = 4, what is the result of the expression 3y + 2?",
    //       "choices": [10, 14, 12, 16],
    //       "answer_index": 1,
    //     },
    //     {
    //       "question":
    //           "Which of the following is the solution set for the inequality 2x - 5 < 1?",
    //       "choices": ["x < 2", "x > 2", "x < 3", "x > 3"],
    //       "answer_index": 2,
    //     },
    //   ],
    // };

    // return data;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget questionCard(
    String question,
    List<dynamic> choices,
    int answerIndex,
    int totalQuestion,
    int questionNumber,
  ) {
    return ValueListenableBuilder<int?>(
      valueListenable: selectedAnswerNotifier,
      builder: (context, selectedAnswer, child) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 40,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    widget.topic.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Question
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(37, 6, 85, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < totalQuestion; i++)
                        Expanded(
                          child: i < questionNumber
                              ? Container(color: Colors.red)
                              : Container(
                                  color: Colors.transparent,
                                  child: Text(questionNumber.toString()),
                                ),
                        ),
                    ],
                  ),
                ),

                Text(
                  question,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 32),

                // Answer choices
                ...List.generate(choices.length, (index) {
                  bool isSelected = selectedAnswer == index;
                  bool isCorrect = answerIndex == index;
                  bool showResult = selectedAnswer != null;

                  Color backgroundColor;
                  Color borderColor;
                  Widget? suffixIcon;
                  Color textColor;

                  if (showResult) {
                    if (isCorrect) {
                      backgroundColor = Color(0xFFE8F5E8);
                      borderColor = Color(0xFF4CAF50);
                      textColor = Color(0xFF2E7D32);
                      suffixIcon = Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 16),
                      );
                    } else if (isSelected) {
                      backgroundColor = Color(0xFFFFEBEE);
                      borderColor = Color(0xFFF44336);
                      textColor = Color(0xFFD32F2F);
                      suffixIcon = Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFFF44336),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      );
                    } else {
                      backgroundColor = Color(0xFFF5F5F5);
                      borderColor = Color(0xFFE0E0E0);
                      textColor = Color(0xFF757575);
                    }
                  } else {
                    backgroundColor = Colors.white;
                    borderColor = Color(0xFFE0E0E0);
                    textColor = Color(0xFF424242);
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    width: double.infinity,
                    child: Material(
                      elevation: showResult && (isCorrect || isSelected)
                          ? 2
                          : 0,
                      borderRadius: BorderRadius.circular(25),
                      shadowColor: Colors.black26,
                      child: InkWell(
                        onTap: selectedAnswer == null
                            ? () {
                                selectedAnswerNotifier.value = index;
                                Future.delayed(
                                  Duration(milliseconds: 1500),
                                  () {
                                    next();
                                  },
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  choices[index].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (suffixIcon != null) suffixIcon,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void next() {
    if (currentIndex < widget.questionsNumber - 1) {
      currentIndex++;
      selectedAnswerNotifier.value = null;
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    selectedAnswerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(132, 57, 246, 1),
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
                  Expanded(
                    child: PageView.builder(
                      itemCount: ai_quiz.length,
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return index == ai_quiz.length - 1
                            ? questionCard(
                                ai_quiz[index]['question'],
                                ai_quiz[index]['choices'],
                                ai_quiz[index]['answer_index'],
                                ai_quiz.length,
                                index + 1,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, 30),
                                    child: Transform.scale(
                                      scale: 0.9,
                                      child: questionCard(
                                        ai_quiz[index + 1]['question'],
                                        ai_quiz[index + 1]['choices'],
                                        ai_quiz[index + 1]['answer_index'],
                                        ai_quiz.length,
                                        index + 1,
                                      ),
                                    ),
                                  ),
                                  questionCard(
                                    ai_quiz[index]['question'],
                                    ai_quiz[index]['choices'],
                                    ai_quiz[index]['answer_index'],
                                    ai_quiz.length,
                                    index + 1,
                                  ),
                                ],
                              );
                      },
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
