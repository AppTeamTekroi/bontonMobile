import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/product/data/model/add_to_cart_model.dart';
import 'package:mobile_erp/features/product/data/model/barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/cart_item_model.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/data/model/get_products_model.dart';
import 'package:mobile_erp/features/product/data/model/post_products_model.dart';
import 'package:mobile_erp/features/product/data/model/remove_from_cart_model.dart';
import '../../../core/enum/post_enum_response.dart';
import '../data/dataSource/product_data_source_impl.dart';

class ProductController extends GetxController {
  late final ProductDataSourceImpl productDataSourceImpl;
  ProductDataSourceImpl pc = Get.put(ProductDataSourceImpl());
  RxList<ProductsModel> productList = <ProductsModel>[].obs;
  // RxBool showDescription = false.obs;
  // final selectedProducts = <ProductsModel>[].obs;
  var selectedProducts = <getProductDataModel>[].obs;
  RxList<bool> showDes = <bool>[].obs;
  var product_count = 0.0.obs;
  var totalAmount = 0.0.obs;
  var totaltax = 0.0.obs;
  var amounttopay = 0.0.obs;
  var subtotal = 0.0.obs;
  var count = 0.0.obs;
  var product_service = "".obs;
  var optionalFields = false.obs;
  var live = true.obs;
  final RxInt selectedRadio = 1.obs;
  final RxInt priceSelectedRadio = 4.obs;
  var isPressed = false.obs;
  var isRoundOffEnabled = false.obs;
  var showOnline = true.obs;
  var notSale = false.obs;
  var isExpanded = false.obs;
  var isClick = false.obs;
  var errorMessage8 = ''.obs;
  var isLoading8 = false.obs;
  var brandData = [].obs;
  var categoryData = [].obs;

  var errorMessage9 = ''.obs;
  var isLoading9 = false.obs;
  var modelData = [].obs;
  var isLoading11 = false.obs;
  var errorMessage11 = ''.obs;

var searchBrand = [];
var searchModel = [];
var searchType = [];


  var detailLoading = false.obs;
  RxList<getProductDataModel> getProductDetailList =
      <getProductDataModel>[].obs;
  RxList<getProductDataModel> getBarcodeSearchDetailList =
      <getProductDataModel>[].obs;
  RxList<getProductDataModel> searchedProductDetailList =
      <getProductDataModel>[].obs;
  RxList<CartItemModel> cartItemDetailList = <CartItemModel>[].obs;
  var finalAmount = 0.0.obs;

  /// add product variables

  var productName = "".obs;
  var searchProduct = "".obs;
  var sellingPrice = "".obs;
  var tax = "".obs;
  var mrp = "".obs;
  var stock_price = "".obs;
  var purchasePrice = "".obs;
  var purchasePriceWithTax = "".obs;
  var hsnCode = "".obs;
  var gst ="".obs;
  var unit = "".obs;
  var category = "".obs;
  var description = "".obs;
  var barcode = "".obs;
  var productImg = "".obs;
  var postData = false.obs;
  var extraDiscount = "0.0".obs;
  var packagingCharges = "0.00".obs;
  var shippingCharges = "0.00".obs;

  RxString qtyInputValue = ''.obs;
  RxString uPriceInputValue = ''.obs;
  RxString pwtInputValue = ''.obs;

  var addToCartLoading = false.obs;

  var barcodeDetailLoading = false.obs;
  var cartLoading = false.obs;
  var unitPriceController;
  var priceWithTaxController;
  var amountController;
  var percentageController;
  var percentage = 0.0.obs;
  var amount = 0.0.obs;


  double getItemDiscount(getProductDataModel item) {
    double itemPrice = double.parse(item.stock_price ?? '0.0');
    double itemQty = item.selectedQty ?? 0.0;
    double itemTotal = itemPrice * itemQty;

    double itemDiscount = 0.0;

    // Percentage discount
    if (percentage.value > 0) {
      itemDiscount = itemTotal * (percentage.value / 100);
    }

    // Fixed discount (distributed evenly)
    else if (amount.value > 0) {
      itemDiscount = amount.value / cartItemDetailList.length;
    }

    // Cap at item total
    if (itemDiscount > itemTotal) {
      itemDiscount = itemTotal;
    }

    return itemDiscount;
  }



  double getFinalTotal() {
    double totalNetBeforeDiscount = 0.0;

    // 1. Calculate total net (without discount, without tax)
    for (var item in selectedProducts) {
      double itemPrice = double.tryParse(item.stock_price ?? '0') ?? 0.0;
      double itemQuantity = item.selectedQty ?? 0.0;
      totalNetBeforeDiscount += (itemPrice * itemQuantity);
    }

    // 2. Calculate total discount
    double totalDiscount = discount1();

    // 3. Apply discount to net
    double totalNetAfterDiscount = totalNetBeforeDiscount - totalDiscount;

    // 4. Calculate tax per item after discount
    double totalTax = 0.0;
    for (var item in selectedProducts) {
      double itemPrice = double.tryParse(item.stock_price ?? '0') ?? 0.0;
      double itemQuantity = item.selectedQty ?? 0.0;
      double itemTotal = itemPrice * itemQuantity;

      // Pro-rate discount across items
      double itemShare =
      (totalNetBeforeDiscount > 0) ? (itemTotal / totalNetBeforeDiscount) : 0.0;
      double itemDiscountShare = totalDiscount * itemShare;

      double discountedItemNet = itemTotal - itemDiscountShare;

      double gstRate = (item.gst ?? 0.0).toDouble(); // now it exists in getProductDataModel
      double itemTax = discountedItemNet * (gstRate / 100);

      totalTax += itemTax;
    }

    // 5. Final total = NetAfterDiscount + Tax
    return totalNetAfterDiscount + totalTax;
  }


  // Function to handle text changes
  void onQtyChanged(String newQty) {
    qtyInputValue.value = newQty;
    print('New qty value: $newQty');
  }

  // Function to handle unit price changes
  void onUnitPriceChanged(String newUnitPrice) {
    // Calculate and update the Price with Tax controller
    // print(newUnitPrice);
    double originalValue = double.tryParse(newUnitPrice) ?? 0.00;
    double newValue = originalValue + originalValue * 0.18;
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    // uPriceInputValue.value = newUnitPrice;
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New unit x price value: $newUnitPrice');
    print('New price x with tax value: $newValue');
  }

  void onPWTChanged(String newPWT) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(newPWT) ?? 0.00;
    double newValue = originalValue / (1 + 0.18);
    unitPriceController.text = newValue.toStringAsFixed(2);
    uPriceInputValue.value = newValue.toStringAsFixed(2);
    print('New unit price value: $newPWT');
    print('New price with tax value: $newValue');
  }

  String getquantity(String name) {
    for (int i = 0; i < cartItemDetailList.length; i++) {
      if (cartItemDetailList[i].product_name == name) {
        return cartItemDetailList[i].quantities!.split('.').first ?? "0";
      }
    }
    return "0";
  }

  void setCartProductInitally() {
    // print('nihal');
    selectedProducts.clear();
    showDes.clear();
    // print('selected products initially:${selectedProducts.length}');
    // print('cart size initially:${cartItemDetailList.length}');

    for (int i = 0; i < cartItemDetailList.length; i++) {
      if (int.parse(cartItemDetailList[i].quantities ?? '0') > 0) {
        getProductDetailList.map((element) {
          if (element.id == cartItemDetailList[i].product_id) {
            // print('testt');
             print('--------base-----${cartItemDetailList[i].base_price}');
            totalAmount.value += double.parse(cartItemDetailList[i].total_amount.toString());
            element.selectedQty = double.parse(cartItemDetailList[i].quantities.toString());
            element.base_price = cartItemDetailList[i].base_price.toString();
            // element.selectedQty = int.parse(cartItemDetailList[i].quantities??'0');
            selectedProducts.add(element);
            showDes.add(false);
            update();
            // selectedProducts.refresh();
          }
        }).toList();
      }
    }
    print('length is : ${selectedProducts.length}');
  }

  double discount1() {
    double totalDiscount = 0;

    for (int i = 0; i < cartItemDetailList.length; i++) {
      // Parse item price and quantity
      double itemPrice = double.parse(cartItemDetailList[i].price!);
      double itemQuantity = double.parse(cartItemDetailList[i].quantities!);
      double itemTotal = itemPrice * itemQuantity;
      double itemDiscount = 0.0;

      // Apply percentage discount if applicable
      if (percentage.value > 0) {
        itemDiscount = ((itemTotal * percentage.value / 100));
        // itemDiscount = item*itemQuantity;
      }

      // Apply fixed discount if applicable
      if (amount.value > 0) {
        itemDiscount = amount.value / cartItemDetailList.length; // Distribute evenly
      }

      // Ensure item discount does not exceed item total
      if (itemDiscount > itemTotal) {
        itemDiscount = itemTotal;
      }

      totalDiscount += itemDiscount;
    }

    return totalDiscount;
  }





  double calculateamount() {
    double amount1 = 0;
    for (int i = 0; i < cartItemDetailList.length; i++) {
      amount1 += (double.parse(cartItemDetailList[i].price!) *
          double.parse(cartItemDetailList[i].quantities!));
    }

    // Ensure amount does not go negative
    if (amount1 < 0) {
      amount1 = 0;
    }
    return amount1;
    print('////////////////////////$amount');
  }

  // double gst1() {
  //   double totalGST = 0;
  //   int itemCount = cartItemDetailList.length;
  //
  //   for (int i = 0; i < itemCount; i++) {
  //     // Calculate GST for the current item and add to the total
  //     totalGST += ((cartItemDetailList[i].gst_percentage! / 100) *
  //         double.parse(cartItemDetailList[i].quantities!));
  //     print("GST for item $i: ${(cartItemDetailList[i].gst_percentage! / 100)}");
  //   }
  //
  //   // Calculate the average GST
  //   double averageGST = itemCount > 0 ? totalGST / itemCount : 0;
  //
  //   print('Average GST: $averageGST');
  //   return averageGST;
  // }


  double calculateamount4() {
    double amount5 = 0;
    for (int i = 0; i < cartItemDetailList.length; i++) {
      amount5 += ((double.parse(cartItemDetailList[i].price!) *
          double.parse(cartItemDetailList[i].quantities!)) + (double.parse(cartItemDetailList[i].gst_amount!) *
          double.parse(cartItemDetailList[i].quantities!)));
    }

    if (percentage.value > 0) {
      amount5 -= (amount5 * percentage.value / 100);
    }

    // Apply fixed discount amount if provided
    if (amount.value > 0) {
      amount5 -= amount.value;
    }


    // Ensure amount does not go negative
    if (amount5 < 0) {
      amount5 = 0;
    }
    return amount5;
    print('////////////////////////$amount');
  }



  void onPercentDiscountChanged(String dis, String original) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(original) ?? 0.00;
    double newValue = originalValue - originalValue * (double.parse(dis) / 100);
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    unitPriceController.text = (newValue / (1 + 0.18)).toStringAsFixed(2);
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New price with tax value: $newValue');
  }

  void onAmountDiscountChanged(String disAmount, String original) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(original) ?? 0.00;
    double newValue = originalValue - double.parse(disAmount);
    // unitPriceController.text = newValue.toStringAsFixed(2);
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    unitPriceController.text = (newValue / (1 + 0.18)).toStringAsFixed(2);
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New price with tax value: $newValue');
  }

  @override
  Future<void> onInit() async {
    productDataSourceImpl = ProductDataSourceImpl();
    // await getProductList();
    getProductDetailsList();
    //
    // ever(count, (_) {
    //   calculateTotalAmount();
    // });
    //
    // ever(count, (_) {
    //   updateTotalAmount();
    // });

    super.onInit();
  }

  void populateProductList() {
    print('tried populating');
    print(getProductDetailList.length);
    searchedProductDetailList.value = [];
    searchedProductDetailList.assignAll(getProductDetailList);
    print(searchedProductDetailList.length);
  }

  double calculateTotalAmount() {
    // Calculate the total price of selected products
    totalAmount.value = 0.0;
    subtotal.value = 0.0;

    // for (final product in getProductDetailList) {
    for (final product in searchedProductDetailList) {
      print('selectedQty in for loop: ${product.selectedQty}');
      if (product.selectedQty != null && product.stock_price != null) {
        print('x');
        subtotal.value += product.selectedQty! * double.parse(product.stock_price!);
      } else {
        product.selectedQty = 0.0;
        // product.stock_price = "0.0";
        subtotal.value += product.selectedQty! * double.parse(product.stock_price!);
      }
    }

    totalAmount.value = subtotal.value + (subtotal.value * 0.18);
    print(totalAmount.value);
    // totalAmount.value = 100;
    return totalAmount.value;
  }

  double updateTotalAmount() {
    double totalAmountValue = totalAmount.value;

    totalAmountValue -= double.tryParse(extraDiscount.value) ?? 0.0;
    totalAmountValue += double.tryParse(packagingCharges.value) ?? 0.0;
    totalAmountValue += double.tryParse(shippingCharges.value) ?? 0.0;
    print("packagingCharges: ${packagingCharges.value}");
    print("totalAmountValue: $totalAmountValue");

    totalAmount.value = totalAmountValue; // Update the totalAmount variable

    return totalAmountValue;
  }

  void toggleExpanded() {
    isExpanded.toggle();
  }

  void clearExtraDiscount() {
    extraDiscount.value =
    "0.00"; // Set the extra discount value to 0.00 or an empty string as needed
  }

  void clearShippingCharges() {
    shippingCharges.value =
    "0.00"; // Set the shipping charges value to 0.00 or an empty string as needed
  }

  void clearPackagingCharges() {
    packagingCharges.value =
    "0.00"; // Set the packaging charges value to 0.00 or an empty string as needed
  }

  int _productLoadId = 0;
  int currentProductPage = 1;
  int productTotalPages = 1;
  var loadingMoreProducts = false.obs;

  Future<void> getProductDetailsList() async {
    print('--------------------');
    final loadId = ++_productLoadId;
    currentProductPage = 1;
    productTotalPages = 1;
    loadingMoreProducts.value = false;
    detailLoading.value = true;
    final response = await productDataSourceImpl.getProductDetailsData(searchBrand, searchModel, searchType);
    if (loadId != _productLoadId) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (loadId == _productLoadId) {
        detailLoading.value = false;
      }
    });
    response.fold((failure) {
      detailLoading.value = false;
      getProductDetailList.value = [];
      searchedProductDetailList.clear();
      print(failure.message);
    }, (resData) {
      currentProductPage = 1;
      productTotalPages = productDataSourceImpl.productListTotalPages;
      getProductDetailList.value = resData;
      searchedProductDetailList.assignAll(getProductDetailList);
    });
    print(getProductDetailList.length);
  }

  Future<void> loadNextProductPage() async {
    if (loadingMoreProducts.value || detailLoading.value) return;
    if (currentProductPage >= productTotalPages) return;

    final loadId = _productLoadId;
    final nextPage = currentProductPage + 1;
    loadingMoreProducts.value = true;
    final response = await productDataSourceImpl.getProductDetailsPage(
      searchBrand,
      searchModel,
      searchType,
      nextPage,
    );
    if (loadId != _productLoadId) {
      loadingMoreProducts.value = false;
      return;
    }
    response.fold((failure) {
      print(failure.message);
    }, (resData) {
      currentProductPage = nextPage;
      getProductDetailList.addAll(resData);
      searchProductByName(searchProduct.value);
    });
    loadingMoreProducts.value = false;
  }

  Future<void> getCartItemDetailsList(String? id) async {
    cartLoading.value = true;
    final response = await productDataSourceImpl.cartItemDetailsData(id ?? '0');
    Future.delayed(Duration(milliseconds: 500), () {
      cartLoading.value = false;
    });
    response.fold((failure) {
      cartLoading.value = false;
      cartItemDetailList.value = [];
      print(failure.message);
    }, (resData) {
      cartItemDetailList.value = resData;
    });
  }

  Future<void> getProductFromBarcode(String filter) async {
    barcodeDetailLoading.value = true;
    final search = BarcodeSearchModel(filter: filter);
    final response = await productDataSourceImpl.getProductFromBarcode(search);

    barcodeDetailLoading.value = false;

    response.fold((failure) {
      barcodeDetailLoading.value = false;
      getBarcodeSearchDetailList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      getBarcodeSearchDetailList.value = resData;
    });
    print(getBarcodeSearchDetailList.length);
    print(searchedProductDetailList.length);
    // searchedProductDetailList.assignAll(getBarcodeSearchDetailList);
    print(searchedProductDetailList.length);
  }

  Rx<Map<String, bool>> cartItemLoadingMap = Rx<Map<String, bool>>({});

  // void setCartItemLoading(String productId, bool isLoading) {
  //   cartItemLoadingMap[productId]!.value = isLoading;
  //   update();
  // }

  // bool getCartItemLoading(String productId) {
  //   return cartItemLoadingMap[productId]?.value ?? false;
  // }

  Future<PostResponseType> postAddToCart(
      String prodId, String custId, String qty, var basePrice) async
  {
    try {
      print(basePrice);

      // addToCartLoading.value = true;
      final detail = AddToCartModel(
        productId: prodId,
        customerId: custId,
        quantities: qty,
        basePrice: basePrice

      );
      print('testing : ${detail.toString()}');
      final response = await productDataSourceImpl.postAddToCart(detail);

      print('API Response: $response');
      // addToCartLoading.value = false;
      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        getCartItemDetailsList(custId);
        // getCustomerList();
        calculateamount();
        // updateTotalAmount();
        // calculateamount();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      addToCartLoading.value = false;
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  Future<PostResponseType> postremovefromCart(
      String prodId, String custId, int qty) async
  {
    try {
      // addToCartLoading.value = true;
      final detail =
      RemoveFromCartModel(productId: prodId, customerId: custId, status: 0);
      print('testing : ${detail.toString()}');
      final response = await productDataSourceImpl.postRemovefromCart(detail);

      print('API Response: $response');
      // addToCartLoading.value = false;
      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        getCartItemDetailsList(custId);
        calculateamount();
        // getCustomerList();
        // updateTotalAmount();
        // calculateamount();

        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      addToCartLoading.value = false;
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void searchProductByName(String? prod) {
    if (prod == null || prod.isEmpty) {
      // Reset the searched list to the original list
      searchedProductDetailList.assignAll(getProductDetailList);
      return;
    }
    searchedProductDetailList.clear();
    for (var product in getProductDetailList) {
      if (product.name!.toLowerCase().contains(prod.toLowerCase())) {
        searchedProductDetailList.add(product);
      }
    }
  }

  // Future<void> getProductList() async {
  //   var response = await productDataSourceImpl.getProductData();

  //   response.fold(
  //       (failure) => {print(failure.message)},
  //       (data) => {
  //             print("Hello from getProductList()"),
  //             data.forEach((element) {
  //               productList.add(new ProductsModel.fromJson(element));
  //             }),
  //             productList.refresh(),
  //             print(productList.value)
  //           });
  // }

  Future<PostResponseType> postProductData() async
  {
    try {
      final prodDetails = PostProductsModel(
        name: productName.value,
        stock_price: stock_price.value,
        barcode: barcode.value,
        description: description.value,
        tax: int.tryParse(tax.value) ?? 0,
        mrp: mrp.value,
        hsn: hsnCode.value,
        product_category_id: 0,
        item_type_id: 1,
        gst: gst.value ?? '',
        // product_name: productName.value,
        // totalPrice: sellingPrice.value,
        // tax: taxRate.value,
        // purchase_price: purchasePrice.value,
        // is_price_with_tax: purchasePriceWithTax.value,
        // hsn_code: hsnCode.value,
        // unit: unit.value,
        // product_category: category.value,
        // description: description.value,
        // product_images: [
        //   PostProductImagesModel(url: 'url1', uid: 'uid1'),
        //   PostProductImagesModel(url: 'url2', uid: 'uid2'),
        //   // You can add more images here if needed
        // ],
      );
      print(prodDetails);
      final response = await productDataSourceImpl.postProductData(prodDetails);

      print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void selectProduct(getProductDataModel product) {
    selectedProducts.add(product);
    update();
  }

  void clearProductList() {
    selectedProducts.clear();
    // showDes.clear();
  }

  void clearDetails() {
    selectedProducts.clear();
    totalAmount.value = 0.0;
    print( totalAmount.value);
    count.value = 0.0;
    product_service.value = "";
    optionalFields.value = false;
    live.value = true;
    subtotal.value = 0.0;
    productName.value = "";
    sellingPrice.value = "";
    tax.value = "";
    stock_price.value = "";
    purchasePrice.value = "";
    purchasePriceWithTax.value = "";
    hsnCode.value = "";
    unit.value = "";
    category.value = "";
    description.value = "";
    barcode.value = "";
    productImg.value = "";
    postData.value = false;
    extraDiscount.value = "0.00";
    packagingCharges.value = "0.00";
    shippingCharges.value = "0.00";

    // for (getProductDataModel prod in getProductDetailList) {
    //   prod.selectedQty = 0;
    // }
    //calculateTotalAmount();
    // print("Total Amount: ${totalAmount.value} Sub Total: ${subtotal.value}");
  }

  void onPriceRadioChanged(int? value) {
    priceSelectedRadio.value = value!;
  }

  void roundOffEnable(bool value) {
    isRoundOffEnabled.value = value;
  }

  void showOnlineEnable(bool value) {
    showOnline.value = value;
  }

  void notSaleEnable(bool value) {
    notSale.value = value;
  }

  void onRadioChanged(int? value) {
    selectedRadio.value = value!;
  }

  void onChanged() {
    isPressed.toggle();
  }

  Future<void> brandsList(BuildContext context) async {
    print('fetching variety api');
    try {
      isLoading8.value = true;
      final result = await pc.brandsList();
      print(result);
      result.fold((failure) {
        isLoading8.value = false;
        errorMessage8.value = 'Error: ${failure.message}';
        brandData.value = [];
        print(errorMessage8.value);
      },
              (responseData) {
            if (responseData['brands'] is List) {
              brandData.value = responseData['brands'];
            }
            print(
                '***********brands data successfully fetched in controller');
            errorMessage8.value = '';
            isLoading8.value = false;
          }
      );
    } catch (e) {
      isLoading8.value = false;
      errorMessage8.value = 'An error occurred: ${e.toString()};';
      print(errorMessage8.value);
    }
  }
  Future<void> modelList(BuildContext context) async {
    print('fetching variety api');
    try {
      isLoading9.value = true;
      final result = await pc.modelList();
      print(result);
      result.fold((failure) {
        isLoading9.value = false;
        errorMessage9.value = 'Error: ${failure.message}';
        modelData.value = [];
        print(errorMessage9.value);
      },
              (responseData) {
            if (responseData['brands'] is List) {
              modelData.value = responseData['brands'];
            }
            print(
                '***********model data successfully fetched in controller');
            errorMessage9.value = '';
            isLoading9.value = false;
          }
      );
    } catch (e) {
      isLoading9.value = false;
      errorMessage9.value = 'An error occurred: ${e.toString()};';
      print(errorMessage9.value);
    }
  }
  Future<void> categoriesList(BuildContext context) async {
    print('fetching variety api');
    try {
      isLoading11.value = true;
      final result = await pc.fetchcategoriesList();
      print(result);
      result.fold((failure) {
        isLoading11.value = false;
        errorMessage11.value = 'Error: ${failure.message}';
        categoryData.value = [];
        print(errorMessage11.value);
      },
              (responseData) {
            if (responseData['data'] is List) {
              categoryData.value = responseData['data'];
            }
            print(
                '***********category data successfully fetched in controller');
            errorMessage11.value = '';
            isLoading11.value = false;
          }
      );
    } catch (e) {
      isLoading11.value = false;
      errorMessage11.value = 'An error occurred: ${e.toString()};';
      print(errorMessage11.value);
    }
  }

}