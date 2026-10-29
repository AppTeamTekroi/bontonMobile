import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/quotation.dart';
import 'package:mobile_erp/features/homescreen/controller/dashboard_controller.dart';
import 'package:mobile_erp/features/homescreen/controller/userController.dart';
import 'package:mobile_erp/features/invoice/presentation/pages/invoicePlaced.dart';
import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import 'package:mobile_erp/features/orders/presentation/pages/orderPlaced.dart';
import 'package:mobile_erp/ui/bonton_logo.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../ui/amountComma.dart';
import '../../Bot.dart';
import '../../product/controller/product_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserController uc = Get.find();
  ProductController pc = Get.find();
  LoginController lc = Get.put(LoginController());
  List<String> list = <String>['This Year', '2022', '2021', '2020'];
  String dropdownValue = 'This Year';
  List<String> names = [
    'Order',
    'Orders List',
    'Invoice',
    // 'Delivery Challan',
    // 'Credit Note',
    'Purchase Order',
    'Expenses',
    'Bot',
    // 'Pro-Forma',
    // 'Indirect Income'
  ];
  List<IconData> icons = [
    Icons.shopping_cart_outlined,
    Icons.receipt_outlined,
    Icons.receipt_long,
    // Icons.local_shipping_outlined,
    // Icons.credit_score_outlined,
    Icons.bookmark_border_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.chat,

    // Icons.calculate_outlined,
    // Icons.money,
  ];

  List<double> iconSizes = [
    40.0,
    40.0,
    40.0,
    // 43.0,
    // 40.0,
    40.0,
    40.0,
    40.0,
    // 40.0,
    // 40.0
  ];

  //This variable to track whether the dialog was shown
  bool _dialogShown = false;
  OrderPlacedController oc = Get.put(OrderPlacedController());
  DashboardController dc = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getheaders();
    // dc.fetchDashboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reset the variable when the app is resumed
      _dialogShown = false;
    }
  }


  final List<Map<String, dynamic>> sliderData2 = [
    {
      "title": "Average Transaction",
      "amount": "₹0",
      "week": "Week: ₹0",
      "color": Colors.blue.shade50,
      "image": Icons.currency_exchange,
    },
    {
      "title": "Units Per Transaction",
      "amount": "0.0",
      "week": "week: 0.0",
      "color": Colors.green.shade50,
      "image": Icons.indeterminate_check_box_sharp,
    },
    {
      "title": "Low Stock Items",
      "amount": "2",
      "week": "0 out of stock",
      "color": Colors.red.shade50,
      "image": Icons.info_outline,
    },
    {
      "title": "Returns / Remarks",
      "amount": "0",
      "week": "This Month",
      "color": Colors.red.shade50,
      "image": Icons.info_outline,
    },
  ];
  var name = '';
  var store = '';
  var date = '';
  Future<void> getheaders() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      name = _pref.getString('name') ?? '--';
      store = _pref.getString('store_code') ?? '--';
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });


  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (!_dialogShown) {
          // If the dialog was not shown before, show it
          _dialogShown = true;

          bool shouldCloseApp = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: Colors.white,
                content: const Text(
                  "Are you sure you want to exit?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        color: AppColors.mainblue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Close the dialog and return true
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "No",
                      style: TextStyle(
                        color: AppColors.mainblue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Close the dialog and return false
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );

          // Reset the variable when the dialog is closed
          _dialogShown = false;

          // Return whether the app should be closed based on user selection
          return shouldCloseApp ?? false;
        } else {
          // If the dialog was already shown, allow the app to be closed without showing the dialog again
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: AppColors.mainblue,
            automaticallyImplyLeading:
            false, // Set to false to remove the back button
            title: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text("BONTON")
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    lc.logOutUser();
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Welcome back $name! ", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),),
                      ),
                      Text("$date", style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),),
                    ],
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Store : $store ", style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,left: 8.0),
                    child: Text("Sales Overview", style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),),
                  ),
                  Obx(() {
                    if (dc.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final sliderData3 = [
                      {
                        "title": "Today's Sales",
                        "amount": dc.todaySales.value,
                        "week": "${dc.todayOrders.value} transactions",
                        "color": Colors.blue.shade50,
                        "image": Icons.currency_exchange,
                      },
                      {
                        "title": "This Week",
                        "amount": (dc.weeklySales.value),
                        "week": "${dc.weeklyOrders.value} transactions",
                        "color": Colors.green.shade50,
                        "image": Icons.trending_up,
                      },
                      {
                        "title": "This Month",
                        "amount": dc.monthlySales.value,
                        "week": "${dc.monthlyOrders.value} transactions",
                        // "color": Colors.red.shade50,
                        "image": Icons.shopping_bag,
                      },
                    ];

                    return CarouselSlider.builder(
                      itemCount: sliderData3.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = sliderData3[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item['title'] as String,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['amount'] as String,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                           ( item['week'] as String),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50, // 👈 light background color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          item['image'] as IconData,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 100,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        padEnds: false,
                        viewportFraction: 0.75,
                      ),
                    );
                  }),


                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,left: 8.0),
                    child: Text("Key Performance Indicators", style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),),
                  ),
                  CarouselSlider.builder(
                    itemCount: sliderData2.length,
                    itemBuilder: (context, index, realIndex) {
                      final item = sliderData2[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🧾 Left side (Text)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['title'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['amount'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['week'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // 🖼️ Right side (Image)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50, // 👈 light background color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['image'],
                                        size: 15,

                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 100,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        viewportFraction: 0.75,
                        initialPage: 0,
                        padEnds: false
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            uc.toggleExpand();
                          },
                          child: Obx(
                                () => Icon(
                              !uc.expand.value
                                  ? Icons.arrow_circle_down
                                  : Icons.arrow_circle_up,
                              color: AppColors.mainblue,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => uc.expand.value
                      ? Container(
                    // height: 160,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisExtent: 112,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                            ),
                            // itemCount: pc.productDataList[0].listings!.length,
                            itemCount: 6,
                            itemBuilder: (context, index) => SizedBox(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      Navigator.push(
                                          context,
                                          (CupertinoPageRoute(
                                              builder: (context) =>
                                              const QuotationScreen())));
                                      // Get.to(InvoiceScreen());
                                    }
                                    if (index == 1) {
                                      Navigator.push(
                                          context,
                                          (CupertinoPageRoute(
                                              builder: (context) =>
                                              const OrderPlacedScreen())));
                                      oc.orderSearch.value = "";
                                    }
                                    if (index == 2) {
                                      // uc.pageNumber.value = 5;
                                      // uc.update();
                                      Navigator.push(
                                          context,
                                          (CupertinoPageRoute(
                                              builder: (context) =>
                                              const InvoicePlacedScreen())));
                                      // TODO
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     (CupertinoPageRoute(
                                      //         builder: (context) =>
                                      //             QuotationScreen())));
                                      // Get.to(InvoiceScreen());
                                    }
                                    // if (index == 3) {
                                    //   // uc.pageNumber.value = 5;
                                    //   // uc.update();
                                    //   Navigator.popUntil(context,
                                    //       (route) => route.isFirst);
                                    //   // TODO
                                    //   // Navigator.pushReplacement(
                                    //   //     context,
                                    //   //     (CupertinoPageRoute(
                                    //   //         builder: (context) =>
                                    //   //             DeliveryChallanScreen())));
                                    //   // Get.to(InvoiceScreen());
                                    // }
                                    // if (index == 4) {
                                    //   // uc.pageNumber.value = 5;
                                    //   // uc.update();
                                    //   Navigator.popUntil(context,
                                    //       (route) => route.isFirst);
                                    //   //TODO
                                    //   // Navigator.pushReplacement(
                                    //   //     context,
                                    //   //     (CupertinoPageRoute(
                                    //   //         builder: (context) =>
                                    //   //             CreditNoteScreen())));
                                    //   // Get.to(InvoiceScreen());
                                    // }
                                    if (index == 5) {
                                      // uc.pageNumber.value = 5;
                                      // uc.update();
                                      // Navigator.push(
                                      //     context,
                                      //     (CupertinoPageRoute(
                                      //         builder: (context) =>
                                      //             ChatBotPage())));
                                      // TODO
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     (CupertinoPageRoute(
                                      //         builder: (context) =>
                                      //             PurchaseOrderScreen())));
                                      // Get.to(InvoiceScreen());
                                    }
                                    if (index == 6) {
                                      // uc.pageNumber.value = 5;
                                      // uc.update();
                                      Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                      //TODO
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     (CupertinoPageRoute(
                                      //         builder: (context) =>
                                      //             ExpenseScreen())));
                                      // Get.to(InvoiceScreen());
                                    }
                                    // if (index == 7) {
                                    //   // uc.pageNumber.value = 5;
                                    //   // uc.update();
                                    //   Navigator.popUntil(context,
                                    //       (route) => route.isFirst);
                                    //   //TODO
                                    //   // Navigator.pushReplacement(
                                    //   //     context,
                                    //   //     (CupertinoPageRoute(
                                    //   //         builder: (context) =>
                                    //   //             ProFormaInvoiceScreen())));
                                    //   // Get.to(InvoiceScreen());
                                    // }
                                    // if (index == 8) {
                                    //   // uc.pageNumber.value = 5;
                                    //   // uc.update();
                                    //   Navigator.popUntil(context,
                                    //       (route) => route.isFirst);
                                    //   //TODO
                                    //   // Navigator.pushReplacement(
                                    //   //     context,
                                    //   //     (CupertinoPageRoute(
                                    //   //         builder: (context) =>
                                    //   //             IndirectIncomeScreen())));
                                    //   // Get.to(InvoiceScreen());
                                    // }
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        // border: Border.all(width: 1),
                                        color: Colors.white),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            icons[index],
                                            color: AppColors.mainblue,
                                            size: iconSizes[index],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            names[index],
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                              FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ))
                      : const SizedBox())
                ],
              ),
            ),
          )),
    );
  }
  Widget _buildRow(String label, dynamic amount, {Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        Text(
          " ₹${amount}",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
