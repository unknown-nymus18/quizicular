import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

const baseUrl = 'http://172.20.10.6:8000';

class AuthApi {
  static late Dio _dio;
  static late PersistCookieJar _cookieJar;
  static bool _initialized = false;

  static const String loginUrl = '$baseUrl/api/account/login/';
  static const String registerUrl = '$baseUrl/api/account/register/';
  static const String logoutUrl = '$baseUrl/api/account/logout/';
  static const String isAuthenticatedUrl =
      '$baseUrl/api/account/is_authenticated/';
  static const getLeaderboardUrl = '$baseUrl/api/account/leaderboard/';

  // Initialize Dio with persistent cookie management
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

  static Future<Response> login(String email, String password) async {
    await _initializeDio();

    final response = await _dio.post(
      loginUrl,
      data: {"email": email, "password": password},
    );

    return response;
  }

  static Future<Response> isAuthenticated() async {
    await _initializeDio();

    final response = await _dio.get(isAuthenticatedUrl);
    return response;
  }

  static Future<Response> register(String email, String password) async {
    await _initializeDio();

    final response = await _dio.post(
      registerUrl,
      data: {"email": email, "password": password},
    );

    return response;
  }

  static Future<Response> logout() async {
    await _initializeDio();

    final response = await _dio.post(logoutUrl);

    // Clear all cookies after logout
    if (response.statusCode == 200) {
      await _cookieJar.deleteAll();
    }

    return response;
  }

  static Future<Response> authenticatedGet(String url) async {
    await _initializeDio();
    return await _dio.get(url);
  }

  static Future<Response> authenticatedPost(
    String url,
    Map<String, dynamic> data,
  ) async {
    await _initializeDio();

    return await _dio.post(url, data: data);
  }

  // Check if user has stored cookies (indicating login state)
  static Future<bool> get isLoggedIn async {
    await _initializeDio();
    final cookies = await _cookieJar.loadForRequest(Uri.parse(baseUrl));
    return cookies.isNotEmpty;
  }

  // Clear stored credentials
  static Future<void> clearCredentials() async {
    await _initializeDio();
    await _cookieJar.deleteAll();
  }

  static Future<Response> getLeaderboard() async {
    await _initializeDio();
    final response = await _dio.get(getLeaderboardUrl);
    return response;
  }
}
