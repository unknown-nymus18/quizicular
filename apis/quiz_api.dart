import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

const baseUrl = 'http://172.20.10.6:8000';

class QuizApi {
  static late Dio _dio;
  static late PersistCookieJar _cookieJar;
  static bool _initialized = false;

  static const quizUrl = baseUrl;
  static const getQuizUrl = '$baseUrl/api/quiz/';

  static Future<void> _initializeDio() async {
    if (_initialized) return;

    // Get application documents directory for storing cookies
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;

    _cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    _dio = Dio();
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    _initialized = true;
  }

  static Future<Response> getQuiz(
    String topic,
    String difficulty,
    int questionsNumber,
  ) async {
    await _initializeDio();
    final response = await _dio.post(
      getQuizUrl,
      data: {
        'topic': topic,
        'diffculty': difficulty,
        'questions_number': questionsNumber,
      },
    );

    return response;
  }
}
