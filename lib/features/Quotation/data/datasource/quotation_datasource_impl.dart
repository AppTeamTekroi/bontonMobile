import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/core/error/failure.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/features/Quotation/data/datasource/quotation_source_repository.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/Quotation/data/model/post_quotation_model.dart';

import '../../../../API/URLConst.dart';
import '../../../../API/store_session.dart';

class QuotationDataSourceImpl implements QuotationSourceRepository {
  QuotationController qc = Get.find<QuotationController>();
  @override
  Future<Either<Failure, PostResponseType>> postQuotationDetails(dynamic data) async {
    try {
      // final Map<String, dynamic> jsonData = data.toJson(); // Convert to JSON
      final stockWhs = await StoreSession.stockWhs();
      final Map<String, dynamic> body = data is Map
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{};
      body['whare_house'] = stockWhs;
      final String jsonString = jsonEncode(body);
      final uri = Uri.parse(URLConst.postOrderPlaced).replace(
        queryParameters: {'stock_whs': stockWhs},
      );
      print(jsonString);
      print(uri);
      var response = await http.post(
        uri,
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );
      var json = jsonDecode(response.body);
      if (json != null && json['salesOrderCopyPdf'] != null) {
        String pdfLink =
            json['salesOrderCopyPdf']['original']['sales_order_copy_pdf'];
        qc.currentorderpdf.value = pdfLink;
        print(pdfLink);
      } else {
        print('salesOrderCopyPdf is null');
      }

      print('11 ${response.body}');
      final jsonResponse = jsonDecode(response.body);
      final jsonDecoded = jsonResponse;

      if (response.statusCode == 200 || response.statusCode == 202) {
        if (jsonResponse['data'] is Map && jsonResponse['data']['id'] != null) {
          return Right(PostResponseType(
            postResponseEnum: PostResponseEnum.success,
            message: jsonResponse['data']['id'].toString(),
          ));
        } else {
          return Right(PostResponseType(
            postResponseEnum: PostResponseEnum.failed,
            message: '${ jsonResponse['message']}',
          ));
        }
        return Right(PostResponseType(postResponseEnum: PostResponseEnum.success, message: jsonDecoded['data']['id'].toString()));
      }else{
        return Right(PostResponseType(postResponseEnum: PostResponseEnum.failed, message: jsonDecoded['message'].toString()));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to post :${e.toString()}'));
    }

    throw Exception('Failed to Post Order Data');
  }

  @override
  Future<Either<Failure, List<GetCustomerPrescriptionModel>>>
      getCustomerPrescriptionData(String c_id, List<String> presId) async {
    try {
      print('Customer prescription Data called ');
      print("*****************************${c_id}");
      var response = await http.get(
        Uri.parse(URLConst.customerPrescriptionURL + c_id),
      );
      print(URLConst.customerPrescriptionURL + c_id);
      // print(jsonDecode(response.body)['customers']);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['prescription'];
        print(data.length);
        List<GetCustomerPrescriptionModel> prod = [];
        List<String> p_Id = [];
        data.forEach((element) {
          prod.add(GetCustomerPrescriptionModel.fromMap(element));
          p_Id.add(element['id'].toString());
        });
        if (p_Id.isNotEmpty) {
          presId.addAll(p_Id);
        }
        presId.add('Other');
        print('length is : ${presId.length}');
        print('customer prescription is : $prod');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
