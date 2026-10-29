import 'package:get/get.dart';

import '../../../ui/amountComma.dart';
import '../data/datasource.dart';

class DashboardController extends GetxController {
  var todaySales = "₹0".obs;
  var weeklySales = "₹0".obs;
  var monthlySales = "₹0".obs;

  var todayOrders = 0.obs;
  var weeklyOrders = 0.obs;
  var monthlyOrders = 0.obs;

  var isLoading = false.obs;
  final DashboardDataSource _dataSource = DashboardDataSource();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading(true);
      final data = await _dataSource.fetchDashboardData();

      todaySales.value = "₹${formatNumber(data['TodaySales'])}";
      weeklySales.value = "₹${formatNumber(data['WeeklySales'])}";
      monthlySales.value = "₹${formatNumber(data['MonthlySales'])}";

      todayOrders.value = data['TodayOrders'];
      weeklyOrders.value = data['WeeklyOrders'];
      monthlyOrders.value = data['MonthlyOrders'];
    } catch (e) {
      print('Dashboard fetch error: $e');
    } finally {
      isLoading(false);
    }
  }
}
