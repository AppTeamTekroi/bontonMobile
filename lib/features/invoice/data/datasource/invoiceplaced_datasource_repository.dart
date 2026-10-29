import 'package:dartz/dartz.dart';
import 'package:mobile_erp/features/invoice/data/model/getinvoiceDetails.dart';
import 'package:mobile_erp/features/invoice/data/model/getinvoicePlacedModel.dart';
import '../../../../core/error/failure.dart';

abstract class InvoicePlacedSourceRepository {
  Future<Either<Failure, List<GetInvoicePlacedModel>>> getInvoicePlacedData();
  Future<Either<Failure, Map<String, dynamic>>> getInvoiceDetails(String currentcardid);
}
