class InvoiceDetailsModel {
  int? id;
  int? userId;
  int? customerId;
  int? prescriptionId;
  String? totalAmount;
  String? amount;
  String? totalGst;
  String? advanceAmount;
  String? discount;
  String? paymentType;
  String? paymentSettlement;
  String? paidAmount;
  int? invoiceStatus;
  int? storeId;
  String? strinvoiceSeries;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? paymentMethods;
  Customer? customer;
  List<invoiceItem>? invoiceItems;
  List<invoicePayment>? invoicePayments;

  var amounttopay;
  var totalTax;
  dynamic invoiceNumber;
  dynamic pdf;
  var balance;


  InvoiceDetailsModel({
    this.id,
    this.userId,
    this.customerId,
    this.prescriptionId,
    this.totalAmount,
    this.amount,
    this.totalGst,
    this.advanceAmount,
    this.discount,
    this.paymentType,
    this.paymentSettlement,
    this.paidAmount,
    this.invoiceStatus,
    this.storeId,
    this.strinvoiceSeries,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentMethods,
    this.customer,
    this.invoiceItems,
    this.invoicePayments,
    this.amounttopay,
    this.totalTax,
    this.invoiceNumber,
    this.pdf,
    this.balance,
  });

  factory InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    var list = json['invoiceitems'] as List;
    List<invoiceItem> invoiceItemsList =
    list.map((i) => invoiceItem.fromJson(i)).toList();

    var paymentList = json['invoicepayments'] as List;
    List<invoicePayment> invoicePaymentsList =
    paymentList.map((i) => invoicePayment.fromJson(i)).toList();

    return InvoiceDetailsModel(
        id: json['id'],
        userId: json['user_id'],
        customerId: json['customer_id'],
        prescriptionId: json['prescription_id'],
        totalAmount: json['total_amount'],
        amount: json['amount'],
        totalGst: json['total_gst'],
        advanceAmount: json['advance_amount'],
        discount: json['discount'],
        paymentType: json['payment_type'],
        paymentSettlement: json['payment_settlement'],
        paidAmount: json['paid_amount'],
        invoiceStatus: json['invoice_status'],
        storeId: json['store_id'],
        strinvoiceSeries: json['str_invoice_series'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        status: json['status'],
        paymentMethods: json['payment_methods'],
        customer: Customer.fromJson(json['customer']),
        invoiceItems: invoiceItemsList,
        invoicePayments: invoicePaymentsList,
        totalTax: json['total_tax'],
        amounttopay: json['amount_to_pay'],
        invoiceNumber: json['invoice_number'],
        pdf: json['invoice_pdf_name'],
        balance : json['balance_amt']

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'customer_id': customerId,
      'prescription_id': prescriptionId,
      'total_amount': totalAmount,
      'amount': amount,
      'total_gst': totalGst,
      'advance_amount': advanceAmount,
      'discount': discount,
      'payment_type': paymentType,
      'payment_settlement': paymentSettlement,
      'paid_amount': paidAmount,
      'invoice_status': invoiceStatus,
      'store_id': storeId,
      'str_invoice_series': strinvoiceSeries,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_methods': paymentMethods,
      'customer': customer?.toJson(),
      'invoiceitems': invoiceItems?.map((item) => item.toJson()).toList(),
      'invoicepayments': invoicePayments?.map((item) => item.toJson()).toList(),
      'amount_to_pay': amounttopay,
      'total_tax': totalTax,
      'balance':balance,
    };
  }
}

class Customer {
  int? id;
  String? companyName;
  String? email;
  dynamic gstin;
  String? name;
  String? phone;
  int? openingBalance;
  dynamic addressId;
  dynamic storeId;
  String? createdAt;
  String? updatedAt;
  int? status;

  Customer({
    this.id,
    this.companyName,
    this.email,
    this.gstin,
    this.name,
    this.phone,
    this.openingBalance,
    this.addressId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      companyName: json['company_name'],
      email: json['email'],
      gstin: json['gstin'],
      name: json['name'],
      phone: json['phone'],
      openingBalance: json['opening_balance'],
      addressId: json['address_id'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'email': email,
      'gstin': gstin,
      'name': name,
      'phone': phone,
      'openingBalance': openingBalance,
      'addressId': addressId,
      'storeId': storeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }
}

class invoiceItem {
  int? id;
  int? invoiceId;
  int? productId;
  dynamic prescriptionId;
  dynamic quantities;
  dynamic price;
  dynamic gstAmount;
  dynamic totalAmount;

  dynamic discount;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic invoiceStatus;
  Product? product;
  dynamic priceAfDisc;
  dynamic taxAmount;
  dynamic  taxpercent;

  invoiceItem({
    this.id,
    this.invoiceId,
    this.productId,
    this.prescriptionId,
    this.quantities,
    this.price,
    this.gstAmount,
    this.totalAmount,
    this.discount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.invoiceStatus,
    this.product,
    this.priceAfDisc,
    this.taxAmount,
    this.taxpercent,

  });

  factory invoiceItem.fromJson(Map<String, dynamic> json) {
    return invoiceItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      productId: json['product_id'],
      prescriptionId: json['prescription_id'],
      quantities: json['quantities'],
      price: json['price'],
      gstAmount: json['gst_amount'],
      totalAmount: json['total_amount'],
      discount: json['discount'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      invoiceStatus: json['invoice_status'],
      product: Product.fromJson(json['product']),
      priceAfDisc: json['price_aft_disc'],
      taxAmount: json['gst_amount'],
      taxpercent: json['gst_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productId': productId,
      'prescriptionId': prescriptionId,
      'quantities': quantities,
      'price': price,
      'gstAmount': gstAmount,
      'totalAmount': totalAmount,
      'discount': discount,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'invoiceStatus': invoiceStatus,
      'product': product,
      'priceAfDisc':priceAfDisc,
      'taxAmount':taxAmount,
      'taxpercent':taxpercent,
    };
  }
}

class Product {
  int? id;
  String? name;
  String? itemCode;

  String? stockPrice;
  String? barcode;
  String? description;
  int? tax;
  String? mrp;
  String? hsn;
  int? productCategoryId;
  int? itemTypeId;
  String? createdAt;
  String? updatedAt;
  int? status;


  Product({
    this.id,
    this.itemCode,
    this.name,
    this.stockPrice,
    this.barcode,
    this.description,
    this.tax,
    this.mrp,
    this.hsn,
    this.productCategoryId,
    this.itemTypeId,
    this.createdAt,
    this.updatedAt,
    this.status,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      itemCode:json['item_no'],
      stockPrice: json['stock_price'],
      barcode: json['barcode'],
      description: json['description'],
      tax: json['gst_percentage'],
      mrp: json['mrp'],
      hsn: json['hsn'],
      productCategoryId: json['product_category_id'],
      itemTypeId: json['item_type_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}
class Prescription {
  final int id;
  final int customerId;
  final double lSph;
  final double lCyl;
  final double lAxis;
  final double lVision;
  final double rSph;
  final double rCyl;
  final double rAxis;
  final double rVision;
  final double add;
  final double pd;
  final String optometrics;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Prescription({
    required this.id,
    required this.customerId,
    required this.lSph,
    required this.lCyl,
    required this.lAxis,
    required this.lVision,
    required this.rSph,
    required this.rCyl,
    required this.rAxis,
    required this.rVision,
    required this.add,
    required this.pd,
    required this.optometrics,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      customerId: json['customer_id'],
      lSph: (json['l_sph'] ?? 0).toDouble(),
      lCyl: (json['l_cyl'] ?? 0).toDouble(),
      lAxis: (json['l_axis'] ?? 0).toDouble(),
      lVision: (json['l_vision'] ?? 0).toDouble(),
      rSph: (json['r_sph'] ?? 0).toDouble(),
      rCyl: (json['r_cyl'] ?? 0).toDouble(),
      rAxis: (json['r_axis'] ?? 0).toDouble(),
      rVision: (json['r_vision'] ?? 0).toDouble(),
      add: (json['add'] ?? 0).toDouble(),
      pd: (json['pd'] ?? 0).toDouble(),
      optometrics: json['optometrics'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'l_sph': lSph,
      'l_cyl': lCyl,
      'l_axis': lAxis,
      'l_vision': lVision,
      'r_sph': rSph,
      'r_cyl': rCyl,
      'r_axis': rAxis,
      'r_vision': rVision,
      'add': add,
      'pd': pd,
      'optometrics': optometrics,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// class OrderPayment {
//   int? id;
//   int? orderId;
//   String? paymentType;
//   num? paidAmount;
//   String? createdAt;
//   String? updatedAt;
//   int? status;
//   dynamic? paymentTime;
//
//   OrderPayment({
//     this.id,
//     this.orderId,
//     this.paymentType,
//     this.paidAmount,
//     this.createdAt,
//     this.updatedAt,
//     this.status,
//     this.paymentTime,
//   });
//
//   factory OrderPayment.fromJson(Map<String, dynamic> json) {
//     return OrderPayment(
//       id: json['id'],
//       orderId: json['order_id'],
//       paymentType: json['payment_type'],
//       paidAmount: json['paid_amount'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       status: json['status'],
//       paymentTime: json['payment_time'],
//     );
//   }
// }

class invoicePayment {
  int? id;
  int? invoiceId;
  String? paymentType;
  num? paidAmount;
  String? createdAt;
  String? updatedAt;
  int? status;
  dynamic paymentTime;

  invoicePayment({
    this.id,
    this.invoiceId,
    this.paymentType,
    this.paidAmount,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentTime,
  });

  factory invoicePayment.fromJson(Map<String, dynamic> json) {
    return invoicePayment(
      id: json['id'],
      invoiceId: json['invoice_id'],
      paymentType: json['payment_type'],
      paidAmount: json['paid_amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      paymentTime: json['payment_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'payment_type': paymentType,
      'paid_amount': paidAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_time': paymentTime,
    };
  }
}