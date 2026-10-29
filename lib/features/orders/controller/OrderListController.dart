import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/orders/data/datasource/orderplaced_datasource_impl.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderDetails.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderPlacedModel.dart';

import '../../Quotation/controller/quotation_controller.dart';

class OrderPlacedController extends GetxController {
  late final OrderPlacedDataSourceImpl orderPlacedDataSourceImpl;

  RxList<GetOrderPlacedModel> orderPlacedList = <GetOrderPlacedModel>[].obs;

  RxList<GetOrderPlacedModel> pendingOrderList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> pendingInvoiceList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> paidInvoiceList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> invoicePlacedList = <GetOrderPlacedModel>[].obs;


  RxList<GetOrderPlacedModel> paidOrderList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> cancelledOrderList = <GetOrderPlacedModel>[].obs;
  Rx<OrderDetailsModel> order = OrderDetailsModel().obs;
  Rx<GetCustomerPrescriptionModel> prescription =
      GetCustomerPrescriptionModel().obs;
  RxList<bool> showdes = <bool>[].obs;
  RxList<bool> boolList = List.generate(20, (_) => false).obs;

  QuotationController qc = Get.put(QuotationController());

  var detailLoading = false.obs;
  var orderDetailFetching = false.obs;
  var successfulFetch = true.obs;
  var totalAmount = 0.0.obs;
  var pendingAmount = 0.0.obs;
  var paidAmount = 0.0.obs;

  var totalInvoiceAmount = 0.0.obs;
  var pendingInvoiceAmount = 0.0.obs;
  var orderSearch = "".obs;
  var currentCardId = ''.obs;
  var expandedDetailsIndices = <int>[].obs;
  var invoicePdf = "".obs;
  var currentorderpdf = "".obs;
  void toggleDetails(int index) {
    if (expandedDetailsIndices.contains(index)) {
      expandedDetailsIndices.remove(index);
    } else {
      expandedDetailsIndices.add(index);
    }
  }

  bool isDetailsExpanded(int index) {
    return expandedDetailsIndices.contains(index);
  }

  Rx<double> record_payment_amout = 0.0.obs;
  Rx<String> record_payment_type = 'UPI'.obs;
  Rx<String> record_payment_settlement = '1'.obs;
  Rx<double> record_payment_balance = 0.00.obs;


  void onInit() async {
    orderPlacedDataSourceImpl = OrderPlacedDataSourceImpl();
    await getOrderPlacedList();
    super.onInit();
  }

  @override
  void dispose() {
    totalAmount.value = 0.0;
    pendingAmount.value = 0.0;
    paidAmount.value = 0.0;
    currentCardId.value = '';
  }

  Future<void> getOrderPlacedList() async {
    detailLoading(true);

    final response = await orderPlacedDataSourceImpl.getOrderPlacedData(orderSearch.value);
    detailLoading.value = false;

    // Reset all lists & amounts
    pendingOrderList.clear();
    cancelledOrderList.clear();
    paidOrderList.clear();
    pendingInvoiceList.clear();
    invoicePlacedList.clear();

    pendingAmount.value = 0.0;
    pendingInvoiceAmount.value = 0.0;
    paidAmount.value = 0.0;
    totalAmount.value = 0.0;



    response.fold((failure) {
      detailLoading(false);
    }, (resData) {
      orderPlacedList.value = resData;

      for (final order in orderPlacedList) {
        print(order.orderStatus);
        print(order.invoiceStatus);
        // ---------- Orders ----------
        if (order.orderStatus == 0) {
          // Order Placed
          pendingOrderList.add(order);
          totalAmount.value += double.tryParse(order.totalAmount.toString()) ?? 0.0;
        } else if (order.orderStatus == 2) {
          // Order Cancelled
          cancelledOrderList.add(order);
        }

        // ---------- Invoices ----------
        if (order.invoiceStatus != null) {
          // keep track of all orders that have an invoice generated
          invoicePlacedList.add(order);

          if (order.invoiceStatus == 1) {
            // Invoice Placed
            pendingInvoiceList.add(order);
            pendingInvoiceAmount.value += double.tryParse(order.totalAmount.toString()) ?? 0.0;
            // totalInvoiceAmount
          }
          // else if (order.invoiceStatus == 2) {
          //   // Invoice Completed (Paid)
          //   paidInvoiceList.add(order);
          //   paidAmount.value += double.tryParse(order.totalAmount.toString()) ?? 0.0;
          // }
        }
      }

    });
  }

  // Future<void> getOrderPlacedList() async {
  //   detailLoading(true);
  //
  //
  //   final response = await orderPlacedDataSourceImpl.getOrderPlacedData();
  //   detailLoading.value = false;
  //   pendingOrderList.value = [];
  //   pendingAmount.value = 0.00;
  //   pendingOrderList.value = [];
  //   orderPlacedList.value = [];
  //
  //   paidAmount.value = 0.00;
  //   totalAmount.value = 0.00;
  //   response.fold((failure) {
  //     detailLoading(false);
  //     // print(failure.message+'jmm,n,,mnm');
  //   }, (resData) {
  //     orderPlacedList.value = resData;
  //     for (int i = 0; i < orderPlacedList.length; i++) {
  //
  //
  //
  //
  //       if (orderPlacedList[i].orderStatus == 0) {
  //
  //         pendingOrderList.add(orderPlacedList[i]);
  //         pendingAmount.value += double.parse(orderPlacedList[i].totalAmount.toString());
  //         } else if (orderPlacedList[i].invoiceStatus == 0) {
  //         pendingOrderList.add(orderPlacedList[i]);
  //         pendingInvoiceAmount.value += double.parse(orderPlacedList[i].totalAmount.toString());
  //
  //       }
  //        else if (orderPlacedList[i].invoiceStatus == 1) {
  //         paidOrderList.add(orderPlacedList[i]);
  //         paidAmount.value += double.parse(orderPlacedList[i].totalAmount.toString());
  //
  //       }
  //       else if (orderPlacedList[i].orderStatus == 2) {
  //         cancelledOrderList.add(orderPlacedList[i]);
  //       }
  //     }
  //   });
  // }

  Future<PostResponseType> getOrderDetails(String id) async {
    orderDetailFetching.value = true;
    invoicePdf.value = "";
    currentorderpdf.value = "";
    final response = await orderPlacedDataSourceImpl.getOrderDetails(id);
    log('id is : - $id');
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      order.value = resData["order_detail"];
      prescription.value = resData["prescription_detail"];
      currentorderpdf.value = resData["sales_order_pdf_url"];
      invoicePdf.value = resData["invoice_pdf"];


      log('order payment type : - ${order.value.orderPayments![0].paymentType ?? ''}');

      showdes.clear();

      int length = order.value.orderItems?.length ?? 0;
      for (int i = 0; i < length; i++) {
        showdes.add(false);
      }

      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success, message: "Success");
    });
    return res;
  }

  Future<PostResponseType> cancelOrder(String id) async {
    orderDetailFetching.value = true;
    final response = await orderPlacedDataSourceImpl.cancelOrder(id);
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      print(resData);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success, message: "Success");
    });
    return res;
  }

  Future<PostResponseType> createInvoice(String id) async {
    orderDetailFetching(true);
    final response = await orderPlacedDataSourceImpl.createInvoice(id);
    orderDetailFetching(false);
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      log('res data is :-$resData');
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success,
          message: jsonEncode(resData.toString()));
    });
    return res;
  }

  Future<PostResponseType> recordPayment(String id) async {
    orderDetailFetching.value = true;
    final response = await orderPlacedDataSourceImpl.recordPayment(
        id,
        record_payment_amout.value,
        record_payment_type.value,
        record_payment_settlement.value,record_payment_balance.value.toString());
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      print(resData);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success,
          message: jsonEncode(resData.toString()));
    });
    return res;
  }
}
