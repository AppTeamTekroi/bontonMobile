import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_erp/constants/sized_box_utils.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/pdfview.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/additionalTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/eyeTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/return_values_bs.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import 'package:mobile_erp/ui/horizonatal_divider.dart';
import 'package:mobile_erp/ui/item_details.dart';
import 'package:mobile_erp/ui/options_button.dart';
import 'package:mobile_erp/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../ui/color/appColor.dart';
import '../../../Quotation/presentation/widget/thermalPrintDialog.dart';
import 'eyeTableOrder.dart';
import 'invoiceView.dart';

class InvoiceDetailsPage extends StatefulWidget {
  InvoiceDetailsPage(
      {super.key,
        required this.id,
        required this.isOrderDetails,
        this.avilable});

  final String id;
  final bool isOrderDetails;
  final double? avilable;
  final Map<String, String> paymentTypeNames = {
    '1': 'Cash',
    '2': 'Card',
    '3': 'Credit',
    '4': 'Online',
    '5': 'UPI',
  };

  @override
  State<InvoiceDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<InvoiceDetailsPage> {
  QuotationController qc = Get.put(QuotationController());
  OrderPlacedController oc = Get.put(OrderPlacedController());
  Set<int> expandedDetailsIndices = {};
  String date = "";
  late double totalPrice;
  late ReturnValuesBS? resultValues;
  var balance = 0.00.obs;
  var totalpaidAmount = 0.00.obs;

  void _showInvoicePopUp(
      BuildContext context, String invoiceNumber, String link)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Text(
                    link,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 5,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      Navigator.of(context).pop();
                      Get.snackbar('Success', 'Link copied to clipboard');
                    },
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  PostResponseType _showRecordPaymentPopUp() {
    PostResponseType returnValue =
    PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    final TextEditingController amountController = TextEditingController();

    // Get.defaultDialog(
    //   title: 'Payment Details',
    //   content: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: <Widget>[
    //         TextField(
    //           controller: amountController,
    //           keyboardType: TextInputType.number,
    //           decoration: const InputDecoration(
    //             labelText: 'Amount',
    //           ),
    //           onChanged: (value) {
    //             oc.record_payment_amout.value = double.parse(value);
    //           },
    //         ),
    //         SizedBoxUtils.height10,
    //         DropdownButtonFormField<String>(
    //           value: oc.record_payment_type.value,
    //           items: ['UPI', 'Cash', 'Card'].map((String type) {
    //             return DropdownMenuItem<String>(
    //               value: type,
    //               child: Text(type),
    //             );
    //           }).toList(),
    //           decoration: const InputDecoration(
    //             labelText: 'Payment Type',
    //           ),
    //           onChanged: (newValue) {
    //             oc.record_payment_type.value = newValue!;
    //           },
    //         ),
    //         SizedBoxUtils.height10,
    //         DropdownButtonFormField<String>(
    //           value: oc.record_payment_settlement.value,
    //           items:
    //               ['Full Payment', 'Advance Payment'].map((String settlement) {
    //             return DropdownMenuItem<String>(
    //               value: settlement,
    //               child: Text(settlement),
    //             );
    //           }).toList(),
    //           decoration: const InputDecoration(
    //             labelText: 'Payment Settlement',
    //           ),
    //           onChanged: (newValue) {
    //             oc.record_payment_settlement.value = newValue!;
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    //   textCancel: 'Cancel',
    //   onCancel: () => Get.back(),
    //   buttonColor: AppColors.mainblue,
    //   textConfirm: 'Proceed',
    //   onConfirm: () async {
    //     returnValue = await oc.recordPayment(widget.id);
    //     Get.back();
    //   },
    // );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBoxUtils.height15,
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  onChanged: (value) {
                    oc.record_payment_amout.value = double.parse(value);
                  },
                ),
                SizedBoxUtils.height15,
                DropdownButtonFormField<String>(
                  value: ['1', '2', '3', '4', '5']
                      .contains(oc.record_payment_type.value)
                      ? oc.record_payment_type.value
                      : null,
                  items: ['1', '2', '3', '4', '5'].map((String type) {
                    final Map<String, String> paymentTypeNames = {
                      '1': 'Cash',
                      '2': 'Card',
                      '3': 'Credit',
                      '4': 'Online',
                      '5': 'UPI',
                    };

                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(paymentTypeNames[type] ?? type),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Type',
                  ),
                  onChanged: (newValue) {
                    oc.record_payment_type.value = newValue!;
                  },
                ),
                SizedBoxUtils.height15,
                DropdownButtonFormField<String>(
                  value: ['1', '2', '3']
                      .contains(oc.record_payment_settlement.value)
                      ? oc.record_payment_settlement.value
                      : null,
                  items: ['1', '2', '3'].map((String settlement) {
                    final Map<String, String> paymentType = {
                      '1': 'Full Amount',
                      '2': 'Advance Amount',
                      '3': 'Partial Amount',
                    };
                    return DropdownMenuItem<String>(
                      value: settlement,
                      child: Text(paymentType[settlement] ?? settlement),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Settlement',
                  ),
                  onChanged: (newValue) {
                    oc.record_payment_settlement.value = newValue!;
                  },
                ),
                SizedBoxUtils.height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainblue,
                          foregroundColor: AppColors.white),
                      onPressed: () async {
                        oc.record_payment_balance.value =
                            balance.value -
                                (double.tryParse(oc.record_payment_amout.value.toString()) ?? 0.0);
                        // print(oc.order.value.paidAmount);
                        // print(oc.record_payment_amout.value);
                        //
                        // print(oc.record_payment_balance.value);
                        returnValue = await oc.recordPayment(widget.id);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        _loadOrderDetails();

                      },
                      child: const Text('Proceed'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return returnValue;
  }

  void invoiceGenerationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Invoice Generation',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBoxUtils.height20,
                const Text('Full amount is required to generate the invoice.',
                    style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                SizedBoxUtils.height20,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _loadOrderDetails() {
    oc.getOrderDetails(widget.id).then((value) {
      if (!mounted) return;
      if (value.postResponseEnum == PostResponseEnum.success) {
        oc.successfulFetch.value = true;
        date = Utils.convertDateFormat(oc.order.value.updatedAt != null
            ? oc.order.value.updatedAt!
            : oc.order.value.createdAt!);
        calculatebalance();
      } else {
        oc.successfulFetch.value = false;
      }
    });
  }

  @override
  void initState() {
    // if (widget.avilable != null) {
    //   balance = widget.avilable;
    // } else {
    //   //  _fetchBalanceFromApi(); // <-- fetch if not passed
    // }
    _loadOrderDetails();
    super.initState();
  }
  void calculatebalance(){
    // ✅ Sum up paidAmount for all items in the order
    double totalPaidAmount = oc.order.value.orderPayments
        ?.map((item) => (item.paidAmount ?? 0.0).toDouble()) // force convert to double
        .fold(0.0, (sum, element) => sum! + element)
        ?? 0.0;


    double orderAmount = double.tryParse(oc.order.value.totalAmount?.toString() ?? '0') ?? 0.0;
    totalpaidAmount.value = totalPaidAmount;

    balance.value = orderAmount - totalPaidAmount;


  }
  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              if (widget.isOrderDetails != true) {
                navigator.pop();
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Obx(() {
          return oc.orderDetailFetching.value
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : oc.successfulFetch.value
              ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBoxUtils.height10,
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Customer Details',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                      ),
                      SizedBoxUtils.height15,
                      GetBuilder<OrderPlacedController>(
                        builder: (oc) => Container(
                          // height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  oc.order.value.customer?.name ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Text(
                                    "Phone Number",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: Text(
                                    oc.order.value.customer?.phone ??
                                        '',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBoxUtils.height15,
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Products Details',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              child: Text(
                                ' (${oc.order.value.orderItems?.length} Product)',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color:
                                    Colors.grey.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBoxUtils.height15,
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: oc.order.value.orderItems?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = oc.order.value.orderItems?[index];


                                  bool isDetailsExpanded = expandedDetailsIndices
                                      .contains(index);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle details expansion on button press
                                        if (isDetailsExpanded) {
                                          expandedDetailsIndices
                                              .remove(index);
                                        } else {
                                          expandedDetailsIndices
                                              .add(index);
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)),
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 15.0),
                                        child: Column(
                                          children: [
                                            SizedBoxUtils.height10,

                                            ItemDetails(
                                              title:
                                              item?.product?.itemCode ?? '--',
                                              value: "${item?.priceAfDisc ?? '--'}",
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            isDetailsExpanded
                                                ? Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                ItemDetails(
                                                  title:
                                                  'Unit Price',
                                                  value: item?.product?.stockPrice ?? '--',
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Quantity',
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                                    ),
                                                    Text(
                                                      '${
                                                          item?.quantities ??
                                                              0
                                                      }',
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                                    ),
                                                  ],
                                                ),
                                                // ItemDetails(
                                                //     title:
                                                //         'Net Amount',
                                                //     value: netAmount
                                                //         .toStringAsFixed(
                                                //             2)),

                                                ItemDetails(
                                                    title:
                                                    'Total Tax(${item?.taxpercent}%)',
                                                    value: '${
                                                        item?.taxAmount ??
                                                            0
                                                    }'),
                                                ItemDetails(
                                                    title:
                                                    'Discount Price',
                                                    value: '${
                                                        item?.discount ??
                                                            0
                                                    }'),
                                                Text(
                                                  item?.product?.name ??
                                                      'Null',
                                                  style:
                                                  const TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize:
                                                    12,
                                                  ),
                                                )
                                              ],
                                            )
                                                : Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  left:
                                                  5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    ' x ${item?.quantities}',
                                                    style: const TextStyle(
                                                        fontSize:
                                                        13,
                                                        color: Colors
                                                            .grey,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Text(
                                                        'Details',
                                                        style: TextStyle(
                                                            fontSize:
                                                            13,
                                                            color:
                                                            Colors.grey,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios,
                                                        color: Colors
                                                            .grey,
                                                        size:
                                                        12,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Obx(() {
                                                  // Use GetX to conditionally show the description
                                                  bool
                                                  showDescription =
                                                  oc.boolList[
                                                  index];
                                                  // final bool showDescription =
                                                  //     boolList[index];
                                                  return showDescription
                                                      ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          8.0,
                                                          vertical:
                                                          10),
                                                      child: Text(
                                                        item?.product
                                                            ?.description ??
                                                            '0',
                                                        style: const TextStyle(
                                                            fontSize:
                                                            14,
                                                            fontWeight:
                                                            FontWeight.w400),
                                                      ))
                                                      : SizedBoxUtils
                                                      .height20;
                                                }),
                                              ],
                                            ),
                                            const HorizontalDivider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      SizedBoxUtils.height15,
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Payment Details',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBoxUtils.width4,
                            Text(
                              ' (${oc.order.value.orderPayments?.length} Payment)',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color:
                                  Colors.grey.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                      SizedBoxUtils.height15,
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListView.builder(

                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: oc.order.value
                                        .orderPayments?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      var item = oc.order.value
                                          .orderPayments?[index];
                                      log('item json is  ------------------- ${item!.toJson()}');
                                      var paidAmount = item.paidAmount ?? 0.0;
                                      var paymentDate = item
                                          .createdAt ==
                                          null
                                          ? ''
                                          : Utils.convertDateFormat(
                                          item.createdAt!);
                                      var paymentTime = item
                                          .createdAt ==
                                          null
                                          ? ''
                                          : Utils.convertTimeFormat(
                                          item.createdAt!);
                                      // var totalPaidAmount = item.paidAmount ?? 0.0;
                                      // var balance = oc.order.value.amount - totalPaidAmount;



                                      // // ✅ Sum up paidAmount for all items in the order
                                      // double totalPaidAmount = oc.order.value.orderPayments
                                      //     ?.map((item) => (item.paidAmount ?? 0.0).toDouble()) // force convert to double
                                      //     .fold(0.0, (sum, element) => sum! + element)
                                      //     ?? 0.0;
                                      //
                                      //
                                      // double orderAmount = double.tryParse(oc.order.value.totalAmount?.toString() ?? '0') ?? 0.0;
                                      //
                                      //  balance = orderAmount - totalPaidAmount;

                                      // log("Order Amount: $orderAmount, Paid: $totalPaidAmount, Balance: $balance");



                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            children: [
                                              SizedBoxUtils.height10,
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Payment ${index + 1}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          14,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                    Text(
                                                      '₹ $paidAmount',
                                                      style: const TextStyle(
                                                          fontSize:
                                                          14,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 10,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Payment Method'),
                                                          Text(
                                                            // Define the map inline within the build method
                                                            {
                                                              '1':
                                                              'Cash',
                                                              '2':
                                                              'Card',
                                                              '3':
                                                              'Credit',
                                                              '4':
                                                              'Online',
                                                              '5':
                                                              'UPI',
                                                            }[item
                                                                .paymentType] ??
                                                                '', // Use the map directly here
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Date'),
                                                          Text(
                                                              paymentDate)
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Time'),
                                                          Text(
                                                              paymentTime)
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              const HorizontalDivider()
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          const Text(
                                            "Total Payment",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            '₹ ${oc.order.value.totalAmount ?? '0'}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          const Text(
                                            "Paid Amount",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            '₹ ${oc.order.value.paidAmount ?? '0'}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          const Text(
                                            "Balance Payment",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Obx(()=>
                                              Text(
                                                // '',
                                                '₹ ${oc.order.value.balance ?? '0'}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                          ),
                                        ],
                                      ),
                                      // QrImageView(
                                      //   data: (double.tryParse(oc.order.value.paidAmount?.toString() ?? '0')?.toStringAsFixed(2)) ?? '0.00',
                                      //   version: QrVersions.auto,
                                      //   size: 100.0,
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBoxUtils.height15,
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Prescription Details',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                      ),
                      SizedBoxUtils.height15,
                      Container(
                        // height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prescription Number',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                oc.order.value.prescriptionId
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  "Prescription",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const OrderEyeDetailsTable(
                                      eye: 'Left',
                                    ),
                                    const OrderEyeDetailsTable(
                                      eye: 'Right',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        'Additional Details : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                      child: Table(
                                        border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        children: [
                                          TableRow(
                                            children: [
                                              _buildBoldTableCell('Add'),
                                              _buildBoldTableCell('PD'),
                                              _buildBoldTableCell('Optometrics'),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              // _buildTableCell(oc.prescription.value.add.toString(), "Add"),
                                              // _buildTableCell(oc.prescription.value.pd.toString(), "PD"),
                                              // _buildTableCell(oc.prescription.value.optometrics??'', "Optometrics"),
                                              _buildTableCell( oc.prescription.value.add.toString(),"Add"),
                                              _buildTableCell(oc.prescription.value.pd.toString(), "PD"),
                                              _buildTableCell(oc.prescription.value.optometrics.toString() ?? '', "Optometrics"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBoxUtils.height15,
                      SizedBoxUtils.height10,
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          '',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   child:
              //   Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Container(
              //     color: Colors.white,
              //     height: 50,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       physics: const AlwaysScrollableScrollPhysics(),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           OptionsButton(
              //             label: 'Order PDF',
              //             icon: Icons.picture_as_pdf_outlined,
              //             onTap: () {
              //               Get.to(() => const pdfview());
              //             },
              //           ),
              //           // SizedBoxUtils.width8,
              //
              //
              //
              //           // widget.isOrderDetails ? SizedBoxUtils.width8 : Container(),
              //           // widget.isOrderDetails
              //           //     ? OptionsButton(
              //           //         label: 'Cancel Order',
              //           //         icon: Icons.cancel,
              //           //         onTap: () async {
              //           //           PostResponseType res =
              //           //               await oc.cancelOrder(widget.id);
              //           //           if (res.postResponseEnum ==
              //           //               PostResponseEnum.success) {
              //           //             oc.getOrderPlacedList();
              //           //             Get.back();
              //           //           } else {
              //           //             Get.snackbar('Error', res.message);
              //           //           }
              //           //         },
              //           //       )
              //           //     : Container(),
              //           SizedBoxUtils.width6,
              //
              //           //  SizedBoxUtils.width8,
              //           // OptionsButton(
              //           //   label: 'Print',
              //           //   icon: Icons.note_outlined,
              //           //   onTap: () {
              //           //     showDialog(
              //           //       context: context,
              //           //       builder: (BuildContext context) {
              //           //         return ThermalPrintDialog();
              //           //       },
              //           //     );
              //           //   },
              //           // ),
              //           // SizedBoxUtils.width8,
              //
              //           if(oc.order.value.pdf != null || oc.order.value.pdf != '')
              //             OptionsButton(
              //               label: 'View INVOICE',
              //               icon: Icons.picture_as_pdf_outlined,
              //               onTap: () {
              //                 String link = 'https://c360.zone/invoice_app/pdf/invoices/${oc.order.value.pdf}' ?? '';
              //                 print(link);
              //                 Get.to(() => invoiceview( pdfString:  link,));
              //               },
              //             ),
              //           SizedBoxUtils.width8,
              //           if(balance.value != 0.0)
              //
              //             OptionsButton(
              //               label: 'Record Payment',
              //               onTap: () => _showRecordPaymentPopUp(),
              //               icon: Icons.attach_money,
              //             ),
              //           if(balance.value == 0.0 ||  oc.order.value.customer?.creditId == 1 || oc.order.value.pdf != null)
              //             OptionsButton(
              //               label: 'Generate Invoice',
              //               icon: Icons.change_circle_outlined,
              //               onTap: () async {
              //                 PostResponseType res = await oc.createInvoice(widget.id);
              //                 if (res.postResponseEnum == PostResponseEnum.success) {
              //                   String raw = res.message;
              //
              //                   // Remove leading/trailing quotes
              //                   if (raw.startsWith('"') && raw.endsWith('"')) {
              //                     raw = raw.substring(1, raw.length - 1);
              //                   }
              //
              //                   // Now raw = {invoice_number: 1000, link: https://...}
              //                   raw = raw.replaceAll("{", "").replaceAll("}", "");
              //
              //                   final parts = raw.split(", ");
              //                   Map<String, dynamic> data = {};
              //
              //                   for (var part in parts) {
              //                     final kv = part.split(": ");
              //                     if (kv.length == 2) {
              //                       data[kv[0].trim()] = kv[1].trim();
              //                     }
              //                   }
              //
              //                   print("Invoice Number: ${data["invoice_number"]}");
              //                   print("Link: ${data["link"]}");
              //
              //                   _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
              //                 } else {
              //                   // Get.snackbar('Error', res.message);
              //                   invoiceGenerationDialog();
              //                 }
              //               },
              //             ),
              //
              //
              //
              //
              //           //            Obx(()=> (oc.order.value.pdf != null && oc.order.value.pdf != '')?
              //           //   OptionsButton(
              //           //   label: 'View INVOICE',
              //           //   icon: Icons.picture_as_pdf_outlined,
              //           //   onTap: () {
              //           //     String link = 'https://c360.zone/invoice_app/pdf/invoices/${oc.order.value.pdf}' ?? '';
              //           //     print(link);
              //           //     Get.to(() => invoiceview( pdfString:  link,));
              //           //   },
              //           // ):
              //           //
              //           //
              //           //
              //           //            balance.value == 0.0 && ((double.tryParse(oc.order.value.totalAmount?.toString() ?? '0') ?? 0.0) == totalpaidAmount.value) ?
              //           //            OptionsButton(
              //           //               label: 'Generate Invoice',
              //           //               icon: Icons.change_circle_outlined,
              //           //               onTap: () async {
              //           //                 PostResponseType res = await oc.createInvoice(widget.id);
              //           //                 if (res.postResponseEnum == PostResponseEnum.success) {
              //           //                   String raw = res.message;
              //           //
              //           //              // Remove leading/trailing quotes
              //           //                   if (raw.startsWith('"') && raw.endsWith('"')) {
              //           //                     raw = raw.substring(1, raw.length - 1);
              //           //                   }
              //           //
              //           //              // Now raw = {invoice_number: 1000, link: https://...}
              //           //                   raw = raw.replaceAll("{", "").replaceAll("}", "");
              //           //
              //           //                   final parts = raw.split(", ");
              //           //                   Map<String, dynamic> data = {};
              //           //
              //           //                   for (var part in parts) {
              //           //                     final kv = part.split(": ");
              //           //                     if (kv.length == 2) {
              //           //                       data[kv[0].trim()] = kv[1].trim();
              //           //                     }
              //           //                   }
              //           //
              //           //                   print("Invoice Number: ${data["invoice_number"]}");
              //           //                   print("Link: ${data["link"]}");
              //           //
              //           //                   _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
              //           //                 } else {
              //           //                   // Get.snackbar('Error', res.message);
              //           //                   invoiceGenerationDialog();
              //           //                 }
              //           //               },
              //           //                                )
              //           //           : OptionsButton(
              //           //                label: 'Record Payment',
              //           //                onTap: () => _showRecordPaymentPopUp(),
              //           //                icon: Icons.attach_money,
              //           //              ),),
              //           SizedBoxUtils.width6,
              //
              //           OptionsButton(
              //             label: 'Send Bill',
              //             icon: Icons.send,
              //             onTap: () async {
              //               await Share.share(
              //                   'Check out this order details from BONTON \n \n ${qc.currentorderpdf.value}');
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // )
            ],
          )
              : const Center(child: Text("Error"));
        }),
        bottomNavigationBar: Obx(()=>
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.white,
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OptionsButton(
                      label: 'Order PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      onTap: () {
                        Get.to(() => const pdfview());
                      },
                    ),
                    // SizedBoxUtils.width8,



                    // widget.isOrderDetails ? SizedBoxUtils.width8 : Container(),
                    // widget.isOrderDetails
                    //     ? OptionsButton(
                    //         label: 'Cancel Order',
                    //         icon: Icons.cancel,
                    //         onTap: () async {
                    //           PostResponseType res =
                    //               await oc.cancelOrder(widget.id);
                    //           if (res.postResponseEnum ==
                    //               PostResponseEnum.success) {
                    //             oc.getOrderPlacedList();
                    //             Get.back();
                    //           } else {
                    //             Get.snackbar('Error', res.message);
                    //           }
                    //         },
                    //       )
                    //     : Container(),
                    SizedBoxUtils.width6,

                    //  SizedBoxUtils.width8,
                    // OptionsButton(
                    //   label: 'Print',
                    //   icon: Icons.note_outlined,
                    //   onTap: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return ThermalPrintDialog();
                    //       },
                    //     );
                    //   },
                    // ),
                    // SizedBoxUtils.width8,

                    (oc.invoicePdf.value.isNotEmpty || oc.invoicePdf.value != '')?
                    OptionsButton(
                      label: 'View INVOICE',
                      icon: Icons.picture_as_pdf_outlined,
                      onTap: () {
                        String link = oc.invoicePdf.value ;
                        print(link);
                        Get.to(() => invoiceview( pdfString:  link,));
                      },
                    ):(balance.value == 0.0 ||  oc.order.value.customer?.creditId == 1 )
                        ?OptionsButton(
                      label: 'Generate Invoice',
                      icon: Icons.change_circle_outlined,
                      onTap: () async {
                        PostResponseType res = await oc.createInvoice(widget.id);
                        if (res.postResponseEnum == PostResponseEnum.success) {
                          String raw = res.message;

                          // Remove leading/trailing quotes
                          if (raw.startsWith('"') && raw.endsWith('"')) {
                            raw = raw.substring(1, raw.length - 1);
                          }

                          // Now raw = {invoice_number: 1000, link: https://...}
                          raw = raw.replaceAll("{", "").replaceAll("}", "");

                          final parts = raw.split(", ");
                          Map<String, dynamic> data = {};

                          for (var part in parts) {
                            final kv = part.split(": ");
                            if (kv.length == 2) {
                              data[kv[0].trim()] = kv[1].trim();
                            }
                          }

                          print("Invoice Number: ${data["invoice_number"]}");
                          print("Link: ${data["link"]}");

                          _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
                          _loadOrderDetails();
                        } else {
                          // Get.snackbar('Error', res.message);
                          invoiceGenerationDialog();
                        }
                      },
                    ):const SizedBox.shrink(),
                    SizedBoxUtils.width8,

                    if(balance.value != 0.0 && oc.order.value.invoiceStatus == 1)
                      Row(
                        children: [

                          OptionsButton(
                            label: 'Record Payment',
                            onTap: () => _showRecordPaymentPopUp(),
                            icon: Icons.attach_money,
                          ),
                          SizedBoxUtils.width8,

                        ],
                      ),




                    //            Obx(()=> (oc.order.value.pdf != null && oc.order.value.pdf != '')?
                    //   OptionsButton(
                    //   label: 'View INVOICE',
                    //   icon: Icons.picture_as_pdf_outlined,
                    //   onTap: () {
                    //     String link = 'https://c360.zone/invoice_app/pdf/invoices/${oc.order.value.pdf}' ?? '';
                    //     print(link);
                    //     Get.to(() => invoiceview( pdfString:  link,));
                    //   },
                    // ):
                    //
                    //
                    //
                    //            balance.value == 0.0 && ((double.tryParse(oc.order.value.totalAmount?.toString() ?? '0') ?? 0.0) == totalpaidAmount.value) ?
                    //            OptionsButton(
                    //               label: 'Generate Invoice',
                    //               icon: Icons.change_circle_outlined,
                    //               onTap: () async {
                    //                 PostResponseType res = await oc.createInvoice(widget.id);
                    //                 if (res.postResponseEnum == PostResponseEnum.success) {
                    //                   String raw = res.message;
                    //
                    //              // Remove leading/trailing quotes
                    //                   if (raw.startsWith('"') && raw.endsWith('"')) {
                    //                     raw = raw.substring(1, raw.length - 1);
                    //                   }
                    //
                    //              // Now raw = {invoice_number: 1000, link: https://...}
                    //                   raw = raw.replaceAll("{", "").replaceAll("}", "");
                    //
                    //                   final parts = raw.split(", ");
                    //                   Map<String, dynamic> data = {};
                    //
                    //                   for (var part in parts) {
                    //                     final kv = part.split(": ");
                    //                     if (kv.length == 2) {
                    //                       data[kv[0].trim()] = kv[1].trim();
                    //                     }
                    //                   }
                    //
                    //                   print("Invoice Number: ${data["invoice_number"]}");
                    //                   print("Link: ${data["link"]}");
                    //
                    //                   _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
                    //                 } else {
                    //                   // Get.snackbar('Error', res.message);
                    //                   invoiceGenerationDialog();
                    //                 }
                    //               },
                    //                                )
                    //           : OptionsButton(
                    //                label: 'Record Payment',
                    //                onTap: () => _showRecordPaymentPopUp(),
                    //                icon: Icons.attach_money,
                    //              ),),

                    OptionsButton(
                      label: 'Send Bill',
                      icon: Icons.send,
                      onTap: () async {
                        await Share.share(
                            'Check out this order details from BONTON \n \n ${qc.currentorderpdf.value}');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Container(
        //     color: Colors.white,
        //     height: 50,
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       physics: const AlwaysScrollableScrollPhysics(),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           OptionsButton(
        //             label: 'Order PDF',
        //             icon: Icons.picture_as_pdf_outlined,
        //             onTap: () {
        //               Get.to(() => const pdfview());
        //             },
        //           ),
        //           // SizedBoxUtils.width8,
        //
        //
        //
        //          // widget.isOrderDetails ? SizedBoxUtils.width8 : Container(),
        //           // widget.isOrderDetails
        //           //     ? OptionsButton(
        //           //         label: 'Cancel Order',
        //           //         icon: Icons.cancel,
        //           //         onTap: () async {
        //           //           PostResponseType res =
        //           //               await oc.cancelOrder(widget.id);
        //           //           if (res.postResponseEnum ==
        //           //               PostResponseEnum.success) {
        //           //             oc.getOrderPlacedList();
        //           //             Get.back();
        //           //           } else {
        //           //             Get.snackbar('Error', res.message);
        //           //           }
        //           //         },
        //           //       )
        //           //     : Container(),
        //           SizedBoxUtils.width6,
        //
        //         //  SizedBoxUtils.width8,
        //           // OptionsButton(
        //           //   label: 'Print',
        //           //   icon: Icons.note_outlined,
        //           //   onTap: () {
        //           //     showDialog(
        //           //       context: context,
        //           //       builder: (BuildContext context) {
        //           //         return ThermalPrintDialog();
        //           //       },
        //           //     );
        //           //   },
        //           // ),
        //           // SizedBoxUtils.width8,
        //
        //           if(oc.order.value.pdf != null || oc.order.value.pdf != '')
        //           OptionsButton(
        //             label: 'View INVOICE',
        //             icon: Icons.picture_as_pdf_outlined,
        //             onTap: () {
        //               String link = 'https://c360.zone/invoice_app/pdf/invoices/${oc.order.value.pdf}' ?? '';
        //               print(link);
        //               Get.to(() => invoiceview( pdfString:  link,));
        //             },
        //           ),
        //
        //          if(balance.value == 0.0 ||  oc.order.value.customer?.creditId == 1 || oc.order.value.pdf != null)
        //           OptionsButton(
        //             label: 'Generate Invoice',
        //             icon: Icons.change_circle_outlined,
        //             onTap: () async {
        //               PostResponseType res = await oc.createInvoice(widget.id);
        //               if (res.postResponseEnum == PostResponseEnum.success) {
        //                 String raw = res.message;
        //
        //                 // Remove leading/trailing quotes
        //                 if (raw.startsWith('"') && raw.endsWith('"')) {
        //                   raw = raw.substring(1, raw.length - 1);
        //                 }
        //
        //                 // Now raw = {invoice_number: 1000, link: https://...}
        //                 raw = raw.replaceAll("{", "").replaceAll("}", "");
        //
        //                 final parts = raw.split(", ");
        //                 Map<String, dynamic> data = {};
        //
        //                 for (var part in parts) {
        //                   final kv = part.split(": ");
        //                   if (kv.length == 2) {
        //                     data[kv[0].trim()] = kv[1].trim();
        //                   }
        //                 }
        //
        //                 print("Invoice Number: ${data["invoice_number"]}");
        //                 print("Link: ${data["link"]}");
        //
        //                 _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
        //               } else {
        //                 // Get.snackbar('Error', res.message);
        //                 invoiceGenerationDialog();
        //               }
        //             },
        //           ),
        //
        //
        //        if(balance.value != 0.0)
        //
        //            OptionsButton(
        //             label: 'Record Payment',
        //             onTap: () => _showRecordPaymentPopUp(),
        //             icon: Icons.attach_money,
        //           ),
        //
        // //            Obx(()=> (oc.order.value.pdf != null && oc.order.value.pdf != '')?
        // //   OptionsButton(
        // //   label: 'View INVOICE',
        // //   icon: Icons.picture_as_pdf_outlined,
        // //   onTap: () {
        // //     String link = 'https://c360.zone/invoice_app/pdf/invoices/${oc.order.value.pdf}' ?? '';
        // //     print(link);
        // //     Get.to(() => invoiceview( pdfString:  link,));
        // //   },
        // // ):
        // //
        // //
        // //
        // //            balance.value == 0.0 && ((double.tryParse(oc.order.value.totalAmount?.toString() ?? '0') ?? 0.0) == totalpaidAmount.value) ?
        // //            OptionsButton(
        // //               label: 'Generate Invoice',
        // //               icon: Icons.change_circle_outlined,
        // //               onTap: () async {
        // //                 PostResponseType res = await oc.createInvoice(widget.id);
        // //                 if (res.postResponseEnum == PostResponseEnum.success) {
        // //                   String raw = res.message;
        // //
        // //              // Remove leading/trailing quotes
        // //                   if (raw.startsWith('"') && raw.endsWith('"')) {
        // //                     raw = raw.substring(1, raw.length - 1);
        // //                   }
        // //
        // //              // Now raw = {invoice_number: 1000, link: https://...}
        // //                   raw = raw.replaceAll("{", "").replaceAll("}", "");
        // //
        // //                   final parts = raw.split(", ");
        // //                   Map<String, dynamic> data = {};
        // //
        // //                   for (var part in parts) {
        // //                     final kv = part.split(": ");
        // //                     if (kv.length == 2) {
        // //                       data[kv[0].trim()] = kv[1].trim();
        // //                     }
        // //                   }
        // //
        // //                   print("Invoice Number: ${data["invoice_number"]}");
        // //                   print("Link: ${data["link"]}");
        // //
        // //                   _showInvoicePopUp(context, (data["invoice_number"]).toString(), data["link"].toString());
        // //                 } else {
        // //                   // Get.snackbar('Error', res.message);
        // //                   invoiceGenerationDialog();
        // //                 }
        // //               },
        // //                                )
        // //           : OptionsButton(
        // //                label: 'Record Payment',
        // //                onTap: () => _showRecordPaymentPopUp(),
        // //                icon: Icons.attach_money,
        // //              ),),
        //           SizedBoxUtils.width6,
        //
        //           OptionsButton(
        //             label: 'Send Bill',
        //             icon: Icons.send,
        //             onTap: () async {
        //               await Share.share(
        //                   'Check out this order details from BONTON \n \n ${qc.currentorderpdf.value}');
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
  Widget _buildBoldTableCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, String field) {
    var displayText = text.isNotEmpty ? text : field;
    if (displayText == "null" ||
        displayText == "Null" ||
        displayText == "null" ||
        displayText == "NULL" ||
        displayText == "") {
      displayText = "0";
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }
}

