import 'package:flutter/material.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/pages/quiz.dart';

class QuizConfig extends StatefulWidget {
  QuizConfig({super.key});

  @override
  State<QuizConfig> createState() => _QuizConfigState();
}

class _QuizConfigState extends State<QuizConfig> {
  TextEditingController topic = TextEditingController();
  String difficulty = "Easy";
  int questionsNumber = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E4F3), // Light purple background
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    "Create Your Quiz",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Subtitle
                Center(
                  child: Text(
                    "Generate custom quizzes from any topic or document",
                    style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),

                // Topic section
                Text(
                  "Enter a topic",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 16),

                // Topic Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: topic,
                    decoration: InputDecoration(
                      hintText:
                          "e.g., World War II, Python Programming, Renaissance Art",
                      hintStyle: TextStyle(
                        color: Color(0xFFA0AEC0),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  "Enter any topic you'd like to be quizzed on",
                  style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                ),
                SizedBox(height: 32),

                // Difficulty Dropdown
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: difficulty,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: ['Easy', 'Medium', 'Hard']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          );
                        })
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        difficulty = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Number of Questions Dropdown
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<int>(
                    value: questionsNumber,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: [5, 10, 15, 20].map<DropdownMenuItem<int>>((
                      int value,
                    ) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value Questions',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        questionsNumber = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 32),

                // Generate Quiz Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle quiz generation
                      if (topic.text.isNotEmpty ||
                          questionsNumber.isNaN ||
                          difficulty.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Quiz(
                              difficulty: difficulty,
                              topic: topic.text,
                              questionsNumber: questionsNumber,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Generate Quiz",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
