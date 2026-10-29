import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/features/customer/data/model/post_cutomers_model.dart';
import 'package:mobile_erp/features/customer/data/model/put_customer_model.dart'
    as pc;

import '../../../core/enum/post_enum_response.dart';
import '../data/datasource/customers_datasource_impl.dart';
import '../data/model/get_customer_model.dart';

class CustomerController extends GetxController {
  late final CustomerDataSourceImpl customerDataSourceImpl;

  RxList<CustomersModel> customersList = <CustomersModel>[].obs;
  RxList<CustomersModel> searchedCustomerDetailList = <CustomersModel>[].obs;
  Rx<CustomersModel?> selectedCustomer = Rx<CustomersModel?>(null);

  var tds_aplicable = false.obs;

  var cust_name = "".obs;
  var dial_code = "".obs;
  var phone1 = ''.obs;
  var phone2 = ''.obs;
  var whatsapp = ''.obs;
  var credit_customer = false.obs;
  var isLoading = false.obs;
  var gstStatus = ''.obs;

  var isphoneLoading = false.obs;
  var phoneStatus = false.obs;

  var phoneNumber = "".obs;
  var email = "".obs;
  var gstNumber = "".obs;
  var companyName = "".obs;
  var postData = false.obs;
  var detailLoading = false.obs;
  var address_1_billing = "".obs;
  var address_2_billing = "".obs;
  var pincode_billing = "".obs;
  var city_billing = "".obs;
  var state_billing = "".obs;

  var address_1_shipping = "".obs;
  var address_2_shipping = "".obs;
  var pincode_shipping = "".obs;
  var city_shipping = "".obs;
  var state_shipping = "".obs;

  var searchCustomer = "".obs;
  var phonerVerfiy = ''.obs;
  @override
  void onInit() async {
    customerDataSourceImpl = CustomerDataSourceImpl();

    await getCustomerList();
    selectedCustomer = Rx<CustomersModel?>(null);
    super.onInit();
  }

  void initializeVariables({bool billing = false, bool shipping = false}) {
    if (billing) {
      address_1_billing.value = '';
      address_2_billing.value = '';
      pincode_billing.value = '';
      city_billing.value = '';
      state_billing.value = '';
    }
    if (shipping) {
      address_1_shipping.value = '';
      address_2_shipping.value = '';
      pincode_shipping.value = '';
      city_shipping.value = '';
      state_shipping.value = '';
    }
  }

  void initializeAddressInUpdate({CustomersModel? customer}) {
    if (customer?.address?.length == 2) {
      address_1_billing.value = customer?.address?[0]?.address_1 ?? '';
      address_2_billing.value = customer?.address?[0]?.address_2 ?? '';
      pincode_billing.value = customer?.address?[0]?.pincode.toString() ?? '';
      city_billing.value = customer?.address?[0]?.city ?? '';
      state_billing.value = customer?.address?[0]?.state ?? '';

      address_1_shipping.value = customer?.address?[1]?.address_1 ?? '';
      address_2_shipping.value = customer?.address?[1]?.address_2 ?? '';
      pincode_shipping.value = customer?.address?[1]?.pincode.toString() ?? '';
      city_shipping.value = customer?.address?[1]?.city ?? '';
      state_shipping.value = customer?.address?[1]?.state ?? '';
    } else if (customer?.address?.length == 1) {
      if (customer?.address?[0]?.type == "billing") {
        address_1_billing.value = customer?.address?[0]?.address_1 ?? '';
        address_2_billing.value = customer?.address?[0]?.address_2 ?? '';
        pincode_billing.value = customer?.address?[0]?.pincode.toString() ?? '';
        city_billing.value = customer?.address?[0]?.city ?? '';
        state_billing.value = customer?.address?[0]?.state ?? '';
      }
      if (customer?.address?[0]?.type == "shipping") {
        address_1_shipping.value = customer?.address?[0]?.address_1 ?? '';
        address_2_shipping.value = customer?.address?[0]?.address_2 ?? '';
        pincode_shipping.value =
            customer?.address?[0]?.pincode.toString() ?? '';
        city_shipping.value = customer?.address?[0]?.city ?? '';
        state_shipping.value = customer?.address?[0]?.state ?? '';
      }
    } else {
      initializeVariables(billing: true, shipping: true);
    }
  }

  // void searchCustomerByNumber(String? num) {
  //   if (num == null || num.isEmpty) {
  //     // Reset the searched list to the original list
  //     searchedCustomerDetailList.assignAll(customersList);
  //     return;
  //   }
  //   print('nihal');
  //   searchedCustomerDetailList.clear();
  //   for (var customer in customersList) {
  //     if (customer.phone != null &&
  //         customer.phone!.toLowerCase().contains(num.toLowerCase())) {
  //       searchedCustomerDetailList.add(customer);
  //     }
  //   }
  // }
  Future<void> verifyGstNumber() async {
    if (gstNumber.value.isEmpty) return;

    try {
      isLoading.value = true;
      companyName.value =  '';
      gstStatus.value  = '';
      final response = await http.post(Uri.parse('${URLConst.baseURL}verify-gst-number'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"gst_number": gstNumber.value}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true &&
            jsonData["data"]["original"]["status"] == true) {

          final gstData = jsonData["data"]["original"]["gstInData"];

          final tradeName = gstData["TradeName"] ?? '';
          final tradeStatus = gstData["Status"] ?? '';

          // Address fields from GST response
          final addrBuilding = gstData["AddrBno"] ?? '';
          final addrFloor = gstData["AddrFlno"] ?? '';
          final addrStreet = gstData["AddrSt"] ?? '';
          final addrLocality = gstData["AddrLoc"] ?? '';
          final addrPincode = gstData["AddrPncd"]?.toString() ?? '';
          final stateCode = gstData["StateCode"]?.toString() ?? '';

          // ✅ Combine address lines cleanly
          final fullAddressLine1 = "$addrBuilding $addrFloor".trim();
          final fullAddressLine2 = "$addrStreet, $addrLocality".trim();

          // ✅ Update company & GST info
          companyName.value = tradeName;
          gstStatus.value = tradeStatus;

          // ✅ Billing Address autofill
          address_1_billing.value = fullAddressLine1;
          address_2_billing.value = fullAddressLine2;
          pincode_billing.value = addrPincode;
          city_billing.value = addrLocality;
          state_billing.value = stateCode;

          // ✅ Shipping Address autofill (same as billing by default)
          address_1_shipping.value = fullAddressLine1;
          address_2_shipping.value = fullAddressLine2;
          pincode_shipping.value = addrPincode;
          city_shipping.value = addrLocality;
          state_shipping.value = stateCode;

          print("✅ GSTIN data applied successfully for billing & shipping!");

        Get.snackbar('Success', 'GST number verified successfully');
        } else {
          Get.snackbar('Error', 'Invalid GST number');
        }
      } else {
        Get.snackbar('Error', 'Failed to verify GST number');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }



  Future<bool> verifyphoneNumber(String number) async {
    if (phoneNumber.value.isEmpty) return false;
    print("StatusCode: ${phoneNumber.value}");

    try {
      isphoneLoading.value = true;
      phonerVerfiy.value = 'Verifying phone number...';

      final response = await http.get(
        Uri.parse('${URLConst.baseURL}phone-number-verify?phone=$number'),
        headers: {'Content-Type': 'application/json'},
      );

      final jsonData = jsonDecode(response.body);

      print("StatusCode: ${response.statusCode}");
      print("Response: $jsonData");

      if (response.statusCode == 200) {
        // verified
        phonerVerfiy.value = 'Verified';
        phoneStatus.value = true;
        return true;

      } else if (response.statusCode == 202) {
        // not verified or some message
        phonerVerfiy.value = jsonData['message'] ?? 'Try again';
        phoneStatus.value = false;
        return false;

      } else {
        // other error
        phonerVerfiy.value = jsonData['message'] ?? "Something went wrong";
        phoneStatus.value = false;
        return false;
      }

    } catch (e) {
      phonerVerfiy.value = 'Something went wrong';
      phoneStatus.value = false;
      return false;

    } finally {
      isphoneLoading.value = false;
    }
  }


  Future<void> getCustomerList() async {
    // print('nihal');
    detailLoading.value = true;
    final response = await customerDataSourceImpl.getCustomerData(searchCustomer.value);
    detailLoading.value = false;
    response.fold((failure) {
      detailLoading.value = false;
      customersList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      customersList.value = resData;
      searchedCustomerDetailList.assignAll(customersList);
    });
  }

  Future<PostResponseType> postCustomerData() async {
    try {
      final custDetails = PostCustomersModel(
          name: cust_name.value,
          phone: phoneNumber.value,
          phone1: phone1.value,
          phone2: phone2.value,
          whatsapp: whatsapp.value,
          email: email.value,
          gstin: gstNumber.value,
          company_name: companyName.value,
          opening_balance: "",
          credit_customer: credit_customer.value == true ? 1 : 0,


          billing_address: address_1_billing.value == '' &&
                  address_2_billing.value == '' &&
                  pincode_billing.value == '' &&
                  city_billing.value == '' &&
                  state_billing.value == ''
              ? BillingAddressModel(
                  type: 'billing',
                  address_1: '-',
                  address_2: '-',
                  city: '-',
                  pincode: '-',
                  state: '-',
                  is_billing: '1',
                  is_shipping: '0')
              : BillingAddressModel(
                  type: 'billing',
                  address_1: address_1_billing.value,
                  address_2: address_2_billing.value,
                  city: city_billing.value,
                  pincode: pincode_billing.value,
                  state: state_billing.value,
                  is_billing: '1',
                  is_shipping: '0'),
          shipping_address: address_1_shipping.value == '' &&
                  address_2_shipping.value == '' &&
                  pincode_shipping.value == '' &&
                  city_shipping.value == '' &&
                  state_shipping.value == ''
              ? ShippingAddressModel(
                  type: 'shipping',
                  address_1: '-',
                  address_2: '-',
                  city: '-',
                  pincode: '-',
                  state: '-',
                  is_billing: '0',
                  is_shipping: '1')
              : ShippingAddressModel(
                  type: 'shipping',
                  address_1: address_1_shipping.value,
                  address_2: address_2_shipping.value,
                  city: city_shipping.value,
                  pincode: pincode_shipping.value,
                  state: state_shipping.value,
                  is_billing: '0',
                  is_shipping: '1'));
      print('testing : ${custDetails.toString()}');
      final response =
          await customerDataSourceImpl.postCustomerData(custDetails);

      print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        // if (true) {
        getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  Future<PostResponseType> putCustomerData(
      String id, CustomersModel? customer) async {
    try {
      final custDetails = pc.PutCustomersModel(
          name: cust_name.value == '' ? customer?.name : cust_name.value,
          phone: phoneNumber.value == '' ? customer?.phone : phoneNumber.value,
          phone1: phone1.value,
          phone2: phone2.value,
          whatsapp: whatsapp.value,

          email: email.value == '' ? customer?.email : email.value,
          gstin: gstNumber.value == '' ? customer?.gstin : gstNumber.value,
          company_name: companyName.value == ''
              ? customer?.company_name
              : companyName.value,
          opening_balance: "123",

          billing_address: pc.BillingAddressModel(
              type: 'billing',
              address_1: address_1_billing.value,
              address_2: address_2_billing.value,
              city: city_billing.value,
              pincode: pincode_billing.value,
              state: state_billing.value,
              is_billing: '1',
              is_shipping: '0'),
          shipping_address: pc.ShippingAddressModel(
              type: 'shipping',
              address_1: address_1_shipping.value,
              address_2: address_2_shipping.value,
              city: city_shipping.value,
              pincode: pincode_shipping.value,
              state: state_shipping.value,
              is_billing: '0',
              is_shipping: '1')
          // type: "billing",
          // address_1: address_1_billing.value,
          // address_2: address_2_billing.value,
          // city: city_billing.value,
          // pincode: pincode_billing.value,
          // state: state_billing.value,
          // is_same: "Y"
          );
      print('testing : ${custDetails.toString()}');
      //TODO: Find from where we can get customer ID
      print(selectedCustomer.value?.cardCode);
      final response =
          await customerDataSourceImpl.putCustomerData(custDetails, id);

      // print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      // if (true) {
      if (response.isRight()) {
        getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void selectCustomer(CustomersModel customer) {
    
    selectedCustomer.value = customer;
    if (selectedCustomer.value != null) print('jdfnkdsfksjfnnjks');
    selectedCustomer.refresh();
    update();
    // refresh();
  }
}
