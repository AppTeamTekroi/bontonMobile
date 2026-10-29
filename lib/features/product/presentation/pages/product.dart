import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/quotation.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/data/model/get_customer_model.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/presentation/pages/add_product.dart';
import 'package:mobile_erp/features/product/presentation/pages/barcode_searched_product.dart';
import 'package:mobile_erp/features/product/presentation/pages/cartScreen.dart';
import 'package:mobile_erp/features/product/presentation/widget/productCard.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/sized_box_utils.dart';
import '../../../../ui/Buttons/buttonBS.dart';
import '../../../../ui/amountComma.dart';
import '../../../../ui/options_button.dart';
import '../../../Quotation/presentation/pages/pdfview.dart';

class SelectProductScreen extends StatefulWidget {
  CustomersModel? customer;
  SelectProductScreen({super.key, this.customer});

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  ProductController pc = Get.find();
  CustomerController cc = Get.find();
  final RxList<int> selectedBrands = <int>[].obs;
  final RxList<int> selectedmodals = <int>[].obs;
  List<int> selectedIndices = [];

  var selectedBrandName = [];
  var selectedModelName = [];
  List<String> selectedIndicesType = [];
  var selectedCategories = <int>[].obs; // RxList<String>

  var selectedCategoryName = <String>[].obs; // RxList<String>

  @override
  void initState() {
    pc.getCartItemDetailsList(cc.selectedCustomer.value?.id.toString());
    pc.brandsList(context);
    pc.modelList(context);
    pc.categoriesList(context);

    // pc.calculateamount();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // pc.count.value = 0.0;
    // pc.clearDetails();

    pc.searchProductByName('');
    cc.initializeVariables(billing: true, shipping: true);
    // pc.getProductDetailsList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pc.setCartProductInitally();
    });
    super.dispose();
  }

  Future<void> fetchType() async {
    pc.searchType = selectedIndicesType;
    await pc.getProductDetailsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 20,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 0, left: 0),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Products",
                      suffixIcon: Obx(
                        () => pc.searchProduct.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    'Search',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                      ),
                      hintStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      pc.searchProduct.value = val;
                      pc.searchProductByName(pc.searchProduct.value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 15.0),
          //   child: GestureDetector(
          //     onTap:   () {
          //       _showBrandsMenu(context);
          //     },
          //
          //     child: const Icon(Icons.filter_alt_rounded
          //   ),
          // ),
          // ),

          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              // onTap: () async {
              //   var res = await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SimpleBarcodeScannerPage(),
              //       ));
              //   if (res != null && res is String) {
              //     print('response from barcode: ${res}');
              //     //  PostResponseType res = await pc.postAddToCart(
              //     //                   widget.product.id.toString(),
              //     //                   cc.selectedCustomer.value?.id.toString() ??
              //     //                       '',
              //     //                   selectedQty.value.toString());
              //     //               // print(res.postResponseEnum);
              //     //               if (res.postResponseEnum ==
              //     //                   PostResponseEnum.success) {
              //     //                 Get.showSnackbar(GetSnackBar(
              //     //                   title: 'Success',
              //     //                   message: 'Product Added to Cart',
              //     //                   snackPosition: SnackPosition.BOTTOM,
              //     //                   backgroundColor: AppColors.mainblue,
              //     //                   duration:
              //     //                       const Duration(milliseconds: 1000),
              //     //                 ));
              //     //               }
              //     await pc.getProductFromBarcode(res);
              //     if (pc.getBarcodeSearchDetailList.isNotEmpty) {
              //       PostResponseType res = await pc.postAddToCart(
              //           pc.getBarcodeSearchDetailList[0].id.toString(),
              //           cc.selectedCustomer.value?.id.toString() ?? '',
              //           '1');
              //       // print(res.postResponseEnum);
              //       if (res.postResponseEnum == PostResponseEnum.success) {
              //         Get.showSnackbar(GetSnackBar(
              //           title: 'Success',
              //           message: 'Product Added to Cart',
              //           snackPosition: SnackPosition.BOTTOM,
              //           backgroundColor: AppColors.mainblue,
              //           duration: const Duration(milliseconds: 1000),
              //         ));
              //       }
              //       print('we got a product with same barcode');
              //     } else {
              //       print('we cant find anything');
              //     }
              //   }
              //   // print('response from barcode: ${res}');
              // },
              child: FaIcon(
                FontAwesomeIcons.barcode,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(
                            customerId: widget.customer?.id.toString()),
                      ));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _filterButton("Category", () => _showCategorySheet(context)),
                _filterButton("Brand", () => _showBrandSheet(context)),
                _filterButton("Model", () => _showModelSheet(context)),
              ],
            ),
          ),

          Obx(
            () => pc.detailLoading.value == true
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // number of items in each row
                                  mainAxisSpacing: 10.0, // spacing between rows
                                  crossAxisSpacing:
                                      10.0, // spacing between columns
                                  childAspectRatio: 0.65),
                          itemCount: 20,
                          // itemCount: pc.getProductDetailList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // child: Shimmer.fromColors(
                                        // baseColor: Colors.grey.shade300,
                                        // highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          // height: 70,
                                          // width: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Container(
                                        height: 20,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        height: 30,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.depth != 0 ||
                              notification is! ScrollUpdateNotification) {
                            return false;
                          }
                          final metrics = notification.metrics;
                          if (metrics.maxScrollExtent > 0 &&
                              metrics.pixels >= metrics.maxScrollExtent - 200) {
                            pc.loadNextProductPage();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          // gridDelegate:
                          // SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount:
                          //     2, // number of items in each row
                          //     mainAxisSpacing: 10.0, // spacing between rows
                          //     crossAxisSpacing:
                          //     10.0, // spacing between columns
                          //     childAspectRatio: 0.75),
                          itemCount: pc.searchedProductDetailList.length +
                              (pc.loadingMoreProducts.value ? 1 : 0),
                          // itemCount: pc.getProductDetailList.length,
                          itemBuilder: (context, index) {
                            if (index >= pc.searchedProductDetailList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.mainblue,
                                    ),
                                  ),
                                ),
                              );
                            }
                            // final product = pc.getProductDetailList[index];
                            final product = pc.searchedProductDetailList[index];
                            print(product.stock_price);
                            if (pc.getProductDetailList.isEmpty) {
                              return Center(
                                  child: Column(
                                children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: AppColors.mainblue,
                                      )),
                                  SizedBox(height: 10),
                                  Text("loading..."),
                                ],
                              ));
                            } else {
                              return IntrinsicHeight(
                                  child: ProductCard(product: product));
                            }
                          }),
                      ),
                    ),
                  ),
          ),
          // Spacer(),
          Obx(() {
            return Visibility(
              visible: pc.calculateamount() > 0.0,
              child: Container(
                padding: EdgeInsets.all(10),
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Amount: ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: "₹ ${formatNumber(pc.calculateamount())}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        pc.setCartProductInitally();

                        // for (var product in pc.getProductDetailList) {
                        //   if (product.selectedQty == null) {
                        //   } else {
                        //     if (product.selectedQty! > 0) {
                        //       var existingProductIndex =
                        //           pc.selectedProducts.indexWhere(
                        //         (selectedProduct) =>
                        //             selectedProduct.id == product.id,
                        //       );

                        //       if (existingProductIndex != -1) {
                        //         var existingProduct =
                        //             pc.selectedProducts[existingProductIndex];
                        //         if (existingProduct.selectedQty !=
                        //             product.selectedQty) {
                        //           // Product already exists and its quantity has changed, update quantity
                        //           existingProduct.selectedQty =
                        //               product.selectedQty!;
                        //         }
                        //       } else {
                        //         pc.selectedProducts.add(product);
                        //         pc.showDes.add(false);
                        //       }
                        //     }
                        //   }
                        // }

                        Navigator.pop(context, pc.selectedProducts);
                      },
                      child: Container(
                        height: double.maxFinite,
                        width: 130,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainblue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  void _showCategorySheet(BuildContext context) {
    final TextEditingController searchCtrl = TextEditingController();
    final RxString searchQuery = "".obs;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 12,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: searchCtrl,
                                  onChanged: (val) {
                                    setModalState(() {
                                      searchQuery.value = val.toLowerCase();
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search category...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.clear),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Obx(() {
                            final filtered = pc.categoryData.where((b) {
                              final name =
                                  (b['name'] ?? '').toString().toLowerCase();
                              return name.contains(searchQuery.value);
                            }).toList();
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8),
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: filtered.length,
                              itemBuilder: (_, index) {
                                final brand = filtered[index];
                                final isSelected =
                                    selectedCategories.contains(brand['id']);

                                return Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (val) {
                                        setModalState(() {
                                          if (isSelected) {
                                            selectedCategories
                                                .remove(brand['id']);
                                            selectedCategoryName
                                                .remove(brand['code']);
                                          } else {
                                            selectedCategories.add(brand['id']);
                                            selectedCategoryName
                                                .add(brand['code']);
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        brand['name'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            pc.searchType = selectedCategoryName;
                            await pc.getProductDetailsList();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainblue,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text("Apply Filter",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        });
  }

  void _showBrandSheet(BuildContext context) {
    final TextEditingController searchCtrl = TextEditingController();
    final RxString searchQuery = "".obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: searchCtrl,
                                onChanged: (val) {
                                  setModalState(() {
                                    searchQuery.value = val.toLowerCase();
                                  });
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: "Search brands...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.clear),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// --- Brand List ---
                      Expanded(
                        child: Obx(() {
                          final filtered = pc.brandData.where((b) {
                            final name =
                                (b['name'] ?? '').toString().toLowerCase();
                            return name.contains(searchQuery.value);
                          }).toList();

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8),
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            itemBuilder: (_, index) {
                              final brand = filtered[index];
                              final isSelected =
                                  selectedBrands.contains(brand['id']);

                              return Row(
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (val) {
                                      setModalState(() {
                                        if (isSelected) {
                                          selectedBrands.remove(brand['id']);
                                          selectedBrandName
                                              .remove(brand['name']);
                                        } else {
                                          selectedBrands.add(brand['id']);
                                          selectedBrandName.add(brand['name']);
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    brand['name'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                      ),

                      /// --- Apply Filter ---
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          pc.searchBrand = selectedBrandName;
                          await pc.getProductDetailsList();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainblue,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: const Text("Apply Filter",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showModelSheet(BuildContext context) {
    final TextEditingController searchCtrl = TextEditingController();
    final RxString searchQuery = "".obs;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 13,
                      top: 12,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: searchCtrl,
                                  onChanged: (val) {
                                    setModalState(() {
                                      searchQuery.value = val.toLowerCase();
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search model...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.clear),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Obx(() {
                            final filtered = pc.modelData.where((m) {
                              final name = (m['model_name'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return name.contains(searchQuery.value);
                            }).toList();
                            return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: filtered.length,
                                itemBuilder: (_, index) {
                                  final model = filtered[index];
                                  final isSelected =
                                      selectedmodals.contains(model['id']);

                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (val) {
                                          setModalState(() {
                                            if (isSelected) {
                                              selectedmodals
                                                  .remove(model['id']);
                                              selectedModelName
                                                  .remove(model['model_name']);
                                            } else {
                                              selectedmodals.add(model['id']);
                                              selectedModelName
                                                  .add(model['model_name']);
                                            }
                                          });
                                        },
                                      ),
                                      Expanded(
                                          child: Text(
                                        model['model_name'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  );
                                });
                          }),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            pc.searchModel = selectedModelName;
                            await pc.getProductDetailsList();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainblue,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text("Apply Filter",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        });
  }

  Widget _filterButton(String title, VoidCallback onTap) {
    return Expanded(
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: GestureDetector(
            onTap: onTap,
            child: Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            )),
      ),
    );
  }
}
