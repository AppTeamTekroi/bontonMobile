// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:get/get.dart';
// import 'package:mobile_erp/core/enum/post_enum_response.dart';
// import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
// import 'package:mobile_erp/features/invoice/data/datasource/invoiceplaced_datasource_impl.dart';
// import 'package:mobile_erp/features/invoice/data/model/getinvoiceDetails.dart';
// import 'package:mobile_erp/features/invoice/data/model/getinvoicePlacedModel.dart';
//
// import '../../Quotation/controller/quotation_controller.dart';
//
// class InvoicePlacedController extends GetxController {
//   late final InvoicePlacedDataSourceImpl invoicePlacedDataSourceImpl;
//
//   RxList<GetInvoicePlacedModel> invoicePlacedList = <GetInvoicePlacedModel>[].obs;
//
//   RxList<GetInvoicePlacedModel> pendinginvoiceList = <GetInvoicePlacedModel>[].obs;
//   RxList<GetInvoicePlacedModel> paidinvoiceList = <GetInvoicePlacedModel>[].obs;
//   RxList<GetInvoicePlacedModel> cancelledinvoiceList = <GetInvoicePlacedModel>[].obs;
//   Rx<InvoiceDetailsModel> invoice = InvoiceDetailsModel().obs;
//   Rx<GetCustomerPrescriptionModel> prescription =
//       GetCustomerPrescriptionModel().obs;
//   RxList<bool> showdes = <bool>[].obs;
//   RxList<bool> boolList = List.generate(20, (_) => false).obs;
//
//   QuotationController qc = Get.put(QuotationController());
//
//   var detailLoading = false.obs;
//   var invoiceDetailFetching = false.obs;
//   var successfulFetch = true.obs;
//   var totalAmount = 0.0.obs;
//   var pendingAmount = 0.0.obs;
//   var paidAmount = 0.0.obs;
//   var currentCardId = ''.obs;
//   var expandedDetailsIndices = <int>[].obs;
//
//   void toggleDetails(int index) {
//     if (expandedDetailsIndices.contains(index)) {
//       expandedDetailsIndices.remove(index);
//     } else {
//       expandedDetailsIndices.add(index);
//     }
//   }
//
//   bool isDetailsExpanded(int index) {
//     return expandedDetailsIndices.contains(index);
//   }
//
//   Rx<double> record_payment_amout = 0.0.obs;
//   Rx<String> record_payment_type = 'UPI'.obs;
//   Rx<String> record_payment_settlement = 'Full Payment'.obs;
//   Rx<double> record_payment_balance = 0.0.obs;
//
//   void onInit() async {
//     invoicePlacedDataSourceImpl = InvoicePlacedDataSourceImpl();
//     await getinvoicePlacedList();
//     super.onInit();
//   }
//
//   @override
//   void dispose() {
//     totalAmount.value = 0.0;
//     pendingAmount.value = 0.0;
//     paidAmount.value = 0.0;
//     currentCardId.value = '';
//   }
//
//   Future<void> getinvoicePlacedList() async {
//     detailLoading(true);
//     pendinginvoiceList.value = [];
//     pendingAmount.value = 0.00;
//     pendinginvoiceList.value = [];
//     paidAmount.value = 0.00;
//     totalAmount.value = 0.00;
//     final response = await invoicePlacedDataSourceImpl.getInvoicePlacedData();
//     detailLoading.value = false;
//     response.fold((failure) {
//       detailLoading(false);
//       invoicePlacedList.value = [];
//       // print(failure.message+'jmm,n,,mnm');
//     }, (resData) {
//       invoicePlacedList.value = resData;
//       for (int i = 0; i < invoicePlacedList.length; i++) {
//
//
//
//
//         if (invoicePlacedList[i].invoiceStatus == 0) {
//
//           pendinginvoiceList.add(invoicePlacedList[i]);
//           pendingAmount.value += double.parse(invoicePlacedList[i].totalAmount.toString());
//         } else if (invoicePlacedList[i].invoiceStatus == 1) {
//           paidinvoiceList.add(invoicePlacedList[i]);
//           paidAmount.value += double.parse(invoicePlacedList[i].totalAmount.toString());
//         } else {
//           cancelledinvoiceList.add(invoicePlacedList[i]);
//         }
//         totalAmount.value +=
//             double.parse(invoicePlacedList[i].totalAmount.toString());
//       }
//     });
//   }
//
//   Future<PostResponseType> getinvoiceDetails(String id) async {
//     invoiceDetailFetching.value = true;
//     final response = await invoicePlacedDataSourceImpl.getInvoiceDetails(id);
//     log('id is : - $id');
//     invoiceDetailFetching.value = false;
//     PostResponseType res =
//         PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
//     response.fold((failure) {
//       invoicePlacedList.value = [];
//       print(failure.message);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.failed, message: failure.message);
//     }, (resData) {
//       invoice.value = resData["invoice_detail"];
//       prescription.value = resData["prescription_detail"];
//       qc.currentinvoicepdf.value = resData["sales_invoice_pdf_url"];
//
//       log('invoice payment type : - ${invoice.value.invoicePayments![0].paymentType ?? ''}');
//
//       showdes.clear();
//
//       int length = invoice.value.invoiceItems?.length ?? 0;
//       for (int i = 0; i < length; i++) {
//         showdes.add(false);
//       }
//
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.success, message: "Success");
//     });
//     return res;
//   }
//
//   Future<PostResponseType> cancelinvoice(String id) async {
//     invoiceDetailFetching.value = true;
//     final response = await invoicePlacedDataSourceImpl.cancelInvoice(id);
//     invoiceDetailFetching.value = false;
//     PostResponseType res =
//         PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
//     response.fold((failure) {
//       invoicePlacedList.value = [];
//       print(failure.message);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.failed, message: failure.message);
//     }, (resData) {
//       print(resData);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.success, message: "Success");
//     });
//     return res;
//   }
//
//   Future<PostResponseType> createInvoice(String id) async {
//     invoiceDetailFetching(true);
//     final response = await invoicePlacedDataSourceImpl.createInvoice(id);
//     invoiceDetailFetching(false);
//     PostResponseType res =
//         PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
//     response.fold((failure) {
//       invoicePlacedList.value = [];
//       print(failure.message);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.failed, message: failure.message);
//     }, (resData) {
//       log('res data is :-$resData');
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.success,
//           message: jsonEncode(resData.toString()));
//     });
//     return res;
//   }
//
//   Future<PostResponseType> recordPayment(String id) async {
//     invoiceDetailFetching.value = true;
//     final response = await invoicePlacedDataSourceImpl.recordPayment(
//         id,
//         record_payment_amout.value,
//         record_payment_type.value,
//         record_payment_settlement.value,record_payment_balance.value.toString());
//     invoiceDetailFetching.value = false;
//     PostResponseType res =
//         PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
//     response.fold((failure) {
//       invoicePlacedList.value = [];
//       print(failure.message);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.failed, message: failure.message);
//     }, (resData) {
//       print(resData);
//       res = PostResponseType(
//           postResponseEnum: PostResponseEnum.success,
//           message: jsonEncode(resData.toString()));
//     });
//     return res;
//   }
// }
