import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDAO {
  static final UserDAO _singleton = UserDAO._internal();
  UserDAO._internal();
  factory UserDAO() {
    return _singleton;
  }
  late Uint8List imageBytes;
  late String username;
  late String email;
  late String captcha;
  Future<Image> fetchImage() async {
    const String url =
        "http://10.0.2.2:8000/image?email=test&name=huy&password=123456";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
      return Image.memory(response.bodyBytes);
    } else {
      // Error handling
      throw Exception('Failed to load image from the server');
    }
  }
  Future<Image> getImage() async {
    const String url =
        "http://10.0.2.2:8000/pay";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
      String headerValue = response.headers['content-disposition'].toString();
      List<String> parts = headerValue.split('=');
      String filename = parts[1].replaceAll('"', '');
      captcha = filename;
      return Image.memory(response.bodyBytes);
    } else {
      // Error handling
      throw Exception('Failed to load image from the server');
    }
  }

  Future<Image> signUp(String username,String email,String hint,String password) async {
    String url =
        "http://10.0.2.2:8000/signup?email=$email&name=$username&password=$password&hint=$hint";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
      this.email = email;
      this.username = username;
      return Image.memory(response.bodyBytes);
    } else {
      // Error handling
      throw Exception('Failed to load image from the server');
    }
  }

  Future<String> login(String email, String password) async {
    String url = "http://10.0.2.2:8000/login?email=$email&password=$password";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      this.email = email;
      username = jsonData['message'];
      return jsonData['message'];
    } else {
      // Error handling
      throw Exception('Failed to load image from the server');
    }
  }

  Future<String> lock() async {
    String url = "http://10.0.2.2:8000/lock";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['message'];
    } else {
      // Error handling
      throw Exception('Failed to load image from the server');
    }
  }

}
