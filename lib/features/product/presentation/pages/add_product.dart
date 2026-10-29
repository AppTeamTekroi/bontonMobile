import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../BottomNav/nav.dart';
import '../../../NavbarScreens/Product/productNav.dart';
import '../../../homescreen/presentation/homeScreen.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

 class _AddProductState extends State<AddProduct> {
   ProductController pc = Get.put(ProductController());
//   var product_service = "product".obs;
//   var productName = "".obs;
//   var sellingPrice = "".obs;
//   var taxRate = "".obs;
//   var purchasePrice = "".obs;
//   var purchasePriceWithTax = "".obs;
//   var hsnCode = "".obs;
//   var productService = ''.obs;
//   var optionalFields = false.obs;
//   var live = false.obs;

  // Future<void> postProductDetails() async {
  //   final url = Uri.parse("YOUR_API_ENDPOINT_HERE");

    // Prepare data to send
    // final data = {
    //   "product_service": product_service.value,
    //   "product_name": productName.value,
    //   "selling_price": sellingPrice.value,
    //   "tax_rate": taxRate.value,
    //   "purchase_price": purchasePrice.value,
    //   "purchase_price_with_tax": purchasePriceWithTax.value,
    //   "hsn_code": hsnCode.value,
    //   'live_status': live.value,
    // };

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(data),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print("Data posted successfully!");
  //     } else {
  //       print("Failed to post data: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
   final barcodeController = TextEditingController();
   final descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Import",
              style: TextStyle(
                color: AppColors.mainblue,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.red.withOpacity(0.4),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 9,
              child: Icon(
                Icons.play_arrow,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text(
                        "Product Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(6),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Radio(
                                value: "product",
                                groupValue: pc.product_service.value,
                                activeColor: AppColors.mainblue,
                                onChanged: (value) {
                                  pc.product_service.value = value!;
                                },
                              ),
                            ),
                            Text("Product"),
                            Obx(
                              () => Radio(
                                value: "service",
                                groupValue: pc.product_service.value,
                                activeColor: AppColors.mainblue,
                                onChanged: (value) {
                                  pc.product_service.value = value!;
                                },
                              ),
                            ),
                            Text("Service"),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Product Name ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: TextField(
                            onChanged: (val) {
                              pc.productName.value = val;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Product Name",
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selling Price",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: TextField(
                                      onChanged: (val) {
                                        pc.stock_price.value = val;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "₹ 10000.0",
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tax",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: TextField(
                                      onChanged: (val) {
                                        pc.tax.value = val;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "0",
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor:
                                AppColors.mainblue,
                                child: Icon(
                                  Icons.add,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                " Enter GSTIN to add/change Tax",
                                style: TextStyle(
                                  color: AppColors.mainblue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Purchase Price",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: TextField(
                                      onChanged: (val) {
                                        pc.mrp.value = val;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "₹ 0.0",
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Purchase Price with GST",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: TextField(
                                      onChanged: (val) {
                                        pc.gst.value = val;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "₹ 0.00",
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "HSN Code (Optional)",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: TextField(
                            onChanged: (val) {
                              pc.hsnCode.value = val;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Optional",
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Units",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                )),
                            padding: EdgeInsets.all(15),
                            height: 200,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Select Product Unit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Unit",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Select Unit",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Optional Fields",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          pc.optionalFields.value = !pc.optionalFields.value;
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.mainblue,
                          child: Obx(
                            () => Icon(
                              pc.optionalFields.value
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Visibility(
                      visible: !pc.optionalFields.value,
                      child: Text(
                        "Description, Barcode, Cess, Category, Product Images",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: pc.optionalFields.value,
                      child: Container(
                        margin: EdgeInsets.all(6),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          )),
                                      padding: EdgeInsets.all(15),
                                      height: 200,
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Select Category",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Category",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      " Select Category",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                        ),
                                      child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      height: 250,  // Adjusted height for more space
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Add Description",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 15), // Adds spacing below the title
                                          TextField(
                                            maxLines: 4,
                                            controller: descriptionController,
                                            onChanged: (val) {
                                              pc.description.value = val;
                                            },// Allows multiline input for detailed description
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                              hintText: 'Enter product description here',
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.all(10),
                                            ),

                                          ),
                                          SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Close the modal
                                              },
                                              child: Text("Save"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      " Add Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(15),
                                        height: 200,
                                        width: double.maxFinite,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              "Barcode",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: barcodeController,
                                                    onChanged: (val) {
                                                      pc.barcode.value = val;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Enter Barcode',
                                                      border: OutlineInputBorder(),
                                                      hintText: 'Scan or enter barcode manually',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                // GestureDetector(
                                                //   onTap: () async {
                                                //     // Add your barcode scanner integration here
                                                //     String scannedCode = await FlutterBarcodeScanner.scanBarcode(
                                                //       "#ff6666", // Customize the scanner color
                                                //       "Cancel",
                                                //       true,
                                                //       ScanMode.BARCODE,
                                                //     );
                                                //     if (scannedCode != '-1') {
                                                //       barcodeController.text = scannedCode;
                                                //       pc.barcode.value = scannedCode; // Update the GetX controller
                                                //     }
                                                //   },
                                                //   child: FaIcon(
                                                //     FontAwesomeIcons.barcode,
                                                //     color: AppColors.mainblue,
                                                //     size: 30,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Barcode",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      " Add Barcode",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.barcode,
                                        color: AppColors.mainblue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          )),
                                      padding: EdgeInsets.all(15),
                                      height: 200,
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Add More Details",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Add More Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Images",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    " Add Product Images",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Obx(
                              () => Row(
                                children: [
                                  FlutterSwitch(
                                    showOnOff: true,
                                    value: pc.live.value,
                                    activeText: "Live",
                                    height: 30,
                                    width: 75,
                                    toggleSize: 23,
                                    padding: 2,
                                    inactiveText: "Offline",
                                    valueFontSize: 13,
                                    activeTextColor: Colors.white,
                                    inactiveTextColor:
                                    AppColors.mainblue,
                                    activeColor:
                                    AppColors.mainblue,
                                    inactiveColor: Colors.white,
                                    inactiveToggleColor:
                                    AppColors.mainblue,
                                    switchBorder: Border.all(
                                        color:
                                            Color.fromARGB(255, 49, 79, 255)),
                                    activeTextFontWeight: FontWeight.normal,
                                    inactiveTextFontWeight: FontWeight.normal,
                                    onToggle: (val) {
                                      pc.live.value = !pc.live.value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomButton(
                    height: 53,
                    title: 'Add Product',
                    buttonText: pc.postData.value == true
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.grey,
                          )
                        : Text(
                            'Add Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                    backgroundColor: AppColors.mainblue,
                    borderRadius: 15,
                    onPressed: () async {
                      pc.postData.value = true;
                      PostResponseType res = await pc.postProductData();
                      pc.postData.value = false;
                      if (res.postResponseEnum == PostResponseEnum.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Data posted successfully')));
                        Get.back();
                        await pc.getProductDetailsList();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error has occurred')));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
