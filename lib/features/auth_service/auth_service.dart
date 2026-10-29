import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../API/URLConst.dart';

class AuthService {
  bool isLoggedIn() {
    // Simulating authentication status
    return false;
  }

  Future<bool> login(String mobile, String password) async {
    try {
      // print('${mobile } and ${password}');
      final url = Uri.parse(URLConst.loginURL);

      final Map<String, dynamic> requestBody = {
        'mobile': mobile,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );


      // print(jsonDecode(response.body)['data']['mobile_user']['name']);
      // print(jsonDecode(response.body)['data']['mobile_user']['email']);
      // print(jsonDecode(response.body)['data']['mobile_user']['id']);
      // print(jsonDecode(response.body)['data']['mobile_user']['mobile']);
      // print(jsonDecode(response.body)['data']['mobile_user']['store_id']);

      if (response.statusCode == 200) {
        print('Login successful!${jsonDecode(response.body)}');
        final date = jsonDecode(response.body)['data']['mobile_user'];
        final name = date['name'];
        final email = date['email'];
        final id = date['id'];
        final mobile_num = date['mobile'];
        final store_id = date['store_code'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('userId', id ?? 0);
        prefs.setString('name', name ?? '');
        prefs.setString('email', email ?? '');
        prefs.setString('mobile', mobile_num ?? '');
        prefs.setString('store_code', store_id ?? '');
        // If logged in, navigate to the home screen
        // Get.to(() => const BottomNav());

        // final data = jsonDecode(response.body);
        // final user = data['data']['mobile_user'];
        //
        // final name = user['name'] ?? '';
        // final email = user['email'] ?? '';
        // final id = user['id'] ?? 0;
        // final mobileNum = user['mobile'] ?? '';
        // final storeCode = user['store_code'] ?? '';
        //
        // // Save to SharedPreferences
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setInt('userId', id);
        // prefs.setString('name', name);
        // prefs.setString('email', email);
        // prefs.setString('mobile', mobileNum.toString());
        // prefs.setString('store_code', storeCode);


        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        print(
            'Login failed. Status code: ${response.statusCode}, Error: ${response.body}');
        Get.snackbar(
          'Login Failed',
          'Please check your credentials and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (error) {
      // Handle other errors
      print('Error during login: $error');
      Get.snackbar(
        'Error',
        'An error occurred during login. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
