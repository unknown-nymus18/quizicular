import 'package:flutter/material.dart';
import 'package:mobile/apis/auth_api.dart';
import 'package:mobile/components/custom_segment_button.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String selectedMode = 'login';

  Widget buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CustomTextField(
            textEditingController: emailController,
            label: "Email",
          ),
          SizedBox(height: 20),
          CustomTextField(
            textEditingController: passwordController,
            label: "Password",
            obscure: true,
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget buildRegisterForm() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CustomTextField(
            textEditingController: firstNameController,
            label: "First Name",
          ),
          SizedBox(height: 20),
          CustomTextField(
            textEditingController: lastNameController,
            label: "Last Name",
          ),
          SizedBox(height: 20),
          CustomTextField(
            textEditingController: emailController,
            label: "Email",
          ),
          SizedBox(height: 20),
          CustomTextField(
            textEditingController: passwordController,
            label: "Password",
            obscure: true,
          ),
          SizedBox(height: 20),
          CustomTextField(
            textEditingController: confirmPasswordController,
            label: "Confirm Password",
            obscure: true,
          ),
        ],
      ),
    );
  }

  void login() async {
    final response = await AuthApi.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void register() {
    AuthApi.register(
      emailController.text.trim(),
      passwordController.text.trim(),
    ).then((response) {
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 19, 21, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                // height: 300,
                width: double.infinity,
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log Into Quizicular",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Generate custom quizzes from any topic.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: CustomSegmentButton(
                        backgroundColor: const Color.fromARGB(
                          255,
                          185,
                          183,
                          183,
                        ),
                        foregroundColor: Colors.white,
                        options: ['Login', 'Sign Up'],
                        onSelectionChanged: (value) {
                          if (value == 0) {
                            setState(() {
                              selectedMode = 'login';
                            });
                          } else {
                            setState(() {
                              selectedMode = 'register';
                            });
                          }
                        },
                      ),
                    ),
                    selectedMode == 'login'
                        ? buildLoginForm()
                        : buildRegisterForm(),
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      child: MaterialButton(
                        color: Color(0xFF667eea),
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                        onPressed: () {
                          if (selectedMode == 'login') {
                            login();
                          } else {
                            register();
                          }
                        },
                        child: Text(
                          selectedMode == 'login' ? 'Login' : 'Register',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
