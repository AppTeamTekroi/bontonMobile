import 'dart:convert';

import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/API/store_session.dart';
import 'package:mobile_erp/features/product/data/dataSource/product_data_source_repository.dart';
import 'package:mobile_erp/features/product/data/model/add_to_cart_model.dart';
import 'package:mobile_erp/features/product/data/model/barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/cart_item_model.dart';
import 'package:mobile_erp/features/product/data/model/get_barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/data/model/remove_from_cart_model.dart';
import '../../../../core/enum/post_enum_response.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';
import '../model/post_products_model.dart';

class ProductDataSourceImpl implements ProductSourceRepository {
  ProductDataSourceImpl();

  int productListTotalPages = 1;

  @override
  Future<Either<Failure, PostResponseType>> postProductData(
      PostProductsModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string
      print(jsonString);
      print(URLConst.postProductURL);
      var response = await http.post(
        Uri.parse(URLConst.postProductURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('2345678 ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Product Data');
  }

  @override
  Future<Either<Failure, PostResponseType>> postAddToCart(
      AddToCartModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.addToCartURL);
      var response = await http.post(
        Uri.parse(URLConst.addToCartURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('addToCart Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Add To Cart');
  }
  @override
  Future<Either<Failure, PostResponseType>> postRemovefromCart(
      RemoveFromCartModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.deleteFromCartUrl+data.customerId!);
      var response = await http.delete(
        Uri.parse(URLConst.deleteFromCartUrl+data.customerId!),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('addToCart Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post remove from Cart');
  }

  @override
  Future<Either<Failure, List<getProductDataModel>>> getProductFromBarcode(
      BarcodeSearchModel data) async {
    try {
      print('nihal from barcode');
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      final stockWhs = await StoreSession.stockWhs();
      print(URLConst.barcodeScanSearchURL);
      var response = await http.post(
        Uri.parse(URLConst.barcodeScanSearchURL).replace(
          queryParameters: {'stock_whs': stockWhs},
        ),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('search Response: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<getProductDataModel> prod = [];
        data.forEach((element) {
          prod.add(getProductDataModel.fromMap(element));
        });
        print('barcode result is : $prod');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Add To Cart');
  }

  @override
  Future<Either<Failure, List<getProductDataModel>>> getProductDetailsData(brand,model,type) {
    return getProductDetailsPage(brand, model, type, 1);
  }

  Future<Either<Failure, List<getProductDataModel>>> getProductDetailsPage(
      brand, model, type, int page) async {
    try {
      print(brand);
      print(model);
      print(type);

      final uri = await _productListUri(brand, model, type, page);
      print("Final URL: $uri");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _productItems(decoded);
        productListTotalPages = _productTotalPages(decoded);
        final prod = _mapProducts(data);
        print('product page $page count: ${prod.length}');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  Future<Uri> _productListUri(brand, model, type, int page) async {
    final stockWhs = await StoreSession.stockWhs();
    final queryParams = <String, dynamic>{
      'stock_whs': stockWhs,
      'page': '$page',
    };

    for (var b in brand) {
      queryParams.putIfAbsent('brand_name[]', () => <String>[]).add(b.toString());
    }
    for (var m in model) {
      queryParams.putIfAbsent('model_name[]', () => <String>[]).add(m.toString());
    }
    for (var t in type) {
      queryParams.putIfAbsent('type_name[]', () => <String>[]).add(t.toString());
    }

    return Uri.parse(URLConst.productURL).replace(queryParameters: {
      for (var key in queryParams.keys) key: queryParams[key],
    });
  }

  List<dynamic> _productItems(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['data'] is List) {
      return List<dynamic>.from(decoded['data'] as List);
    }
    return [];
  }

  int _productTotalPages(dynamic decoded) {
    if (decoded is Map && decoded['pagination'] is Map) {
      final pages = decoded['pagination']['total_pages'];
      if (pages is int && pages > 0) return pages;
      if (pages is num && pages > 0) return pages.toInt();
    }
    return 1;
  }

  List<getProductDataModel> _mapProducts(List<dynamic> data) {
    final prod = <getProductDataModel>[];
    for (final element in data) {
      if (element is! Map) continue;
      try {
        prod.add(getProductDataModel.fromMap(Map<String, dynamic>.from(element)));
      } catch (e) {
        print('Skip product: $e');
      }
    }
    return prod;
  }

  @override
  Future<Either<Failure, List<CartItemModel>>> cartItemDetailsData(
      String id) async {
    try {
      // print(URLConst.CartItemURL + id);
      var response = await http.post(
        Uri.parse(URLConst.CartItemURL + id),
        body: "",
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<CartItemModel> cart = [];
        data.forEach((element) {
          cart.add(CartItemModel.fromMap(element));
        });
        print('Cart have : $cart');
        return Right(cart);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getProductData() async {
    try {
      final stockWhs = await StoreSession.stockWhs();
      var response = await http.get(
        Uri.parse(URLConst.productURL).replace(
          queryParameters: {'stock_whs': stockWhs},
        ),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded is Map && decoded['data'] is List)
                ? List<dynamic>.from(decoded['data'] as List)
                : [];

        return Right(data);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed to login!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  Future<Either<Failure, dynamic>> brandsList() async
  {

    try {
      // final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('https://c360.zone/invoice_app/api/brands');
      print(url);
      final response = await http.get(
        url,
        // headers: headers,
      );

      //  print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Variety list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  Future<Either<Failure, dynamic>> modelList() async
  {

    try {
      // final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('https://c360.zone/invoice_app/api/models');
      print(url);
      final response = await http.get(
        url,
        // headers: headers,
      );

      //  print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Variety list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, dynamic>> fetchcategoriesList() async
  {

    try {
      // final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}product-categories');
      print(url);
      final response = await http.get(
        url,
        // headers: headers,
      );

      //  print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Variety list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
}