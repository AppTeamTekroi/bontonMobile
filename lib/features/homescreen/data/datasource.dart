import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/API/store_session.dart';

class DashboardDataSource {
  // final String baseUrl = 'https://c360.zone/invoice_app/api/dashboard';

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final userId = await StoreSession.userId();
      final response = await http.get(
        Uri.parse('${URLConst.baseURL}dashboard?userId=$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception('Failed: ${data['message']}');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}
