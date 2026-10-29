
class OrderDetailsModel {
  var id;
  var userId;
  var customerId;
  var prescriptionId;
  var  totalAmount;
  var amount;
  var totalGst;
  var advanceAmount;
  var discount;
  var paymentType;
  var paymentSettlement;
  var  paidAmount;
  var orderStatus;
  var invoiceStatus;

  var storeId;
  var  strOrderSeries;
  var  createdAt;
  var  updatedAt;
  var status;
  var  paymentMethods;
  Customer? customer;
  List<OrderItem>? orderItems;
  List<OrderPayment>? orderPayments;

  var amounttopay;
  var totalTax;
  var invoiceNumber;
  var  balance;


  OrderDetailsModel({
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
    this.orderStatus,
    this.storeId,
    this.strOrderSeries,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentMethods,
    this.customer,
    this.orderItems,
    this.orderPayments,
    this.amounttopay,
    this.totalTax,
    this.invoiceNumber,
    this.balance,
    this.invoiceStatus
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItemsList = [];
    if (json['orderitems'] != null && json['orderitems'] is List) {
      orderItemsList = (json['orderitems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    List<OrderPayment> orderPaymentsList = [];
    if (json['orderpayments'] != null && json['orderpayments'] is List) {
      orderPaymentsList = (json['orderpayments'] as List)
          .map((item) => OrderPayment.fromJson(item))
          .toList();
    }

    return OrderDetailsModel(
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
      orderStatus: json['order_status'],
      invoiceStatus: json['invoice_status'],
      storeId: json['store_id'],
      strOrderSeries: json['str_order_series'] ?? '--',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      paymentMethods: json['payment_methods'],

      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,

      orderItems: orderItemsList,
      orderPayments: orderPaymentsList,

      totalTax: json['total_tax'],
      amounttopay: json['amount_to_pay'],
      invoiceNumber: json['invoice_number'],
      balance: (json['balance_amt'] ?? 0).toDouble(),
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
      'order_status': orderStatus,
      'store_id': storeId,
      'str_order_series': strOrderSeries,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_methods': paymentMethods,
      'customer': customer?.toJson(),
      'orderitems': orderItems?.map((item) => item.toJson()).toList(),
      'orderpayments': orderPayments?.map((item) => item.toJson()).toList(),
      'amount_to_pay': amounttopay,
      'total_tax': totalTax,
      'balance':balance,
      'invoiceStatus':invoiceStatus,
    };
  }
}

class Customer {
  var id;
  var  companyName;
  var  email;
  var  gstin;
  var  name;
  var  phone;
  var openingBalance;
  var  addressId;
  var  storeId;
  var  createdAt;
  var  updatedAt;
  var status;
  var creditId;

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
    this.creditId,
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
      creditId: json['credit_customer'],

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
      'creditId':creditId,
    };
  }
}

class OrderItem {
  var id;
  var orderId;
  var productId;
  var  prescriptionId;
  var  quantities;
  var  price;
  var  gstAmount;
  var  totalAmount;

  var  discount;
  var status;
  var  createdAt;
  var  updatedAt;
  var  orderStatus;
  var  product;
  var  priceAfDisc;
  var  taxAmount;
  var   taxpercent;

  OrderItem({
    this.id,
    this.orderId,
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
    this.orderStatus,
    this.product,
    this.priceAfDisc,
    this.taxAmount,
    this.taxpercent,

  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
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
      orderStatus: json['order_status'],
      product: Product.fromJson(json['product']),
      priceAfDisc: json['price_aft_disc'],
      taxAmount: json['gst_amount'],
      taxpercent: json['gst_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
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
      'orderStatus': orderStatus,
      'product': product,
      'priceAfDisc':priceAfDisc,
      'taxAmount':taxAmount,
      'taxpercent':taxpercent,
    };
  }
}

class Product {
  var id;
  var  name;
  var  itemCode;

  var  stockPrice;
  var  barcode;
  var  description;
  var tax;
  var  mrp;
  var  hsn;
  var productCategoryId;
  var itemTypeId;
  var  createdAt;
  var  updatedAt;
  var status;


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
  var id;
  var customerId;
  var  lSph;
  var  lCyl;
  var  lAxis;
  var  lVision;
  var  rSph;
  var  rCyl;
  var  rAxis;
  var  rVision;
  var  add;
  var  pd;
  var  optometrics;
  var status;
  DateTime createdAt;
  DateTime updatedAt;

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

class OrderPayment {
  var id;
  var orderId;
  var  paymentType;
  var paidAmount;
  var  createdAt;
  var  updatedAt;
  var status;
  dynamic paymentTime;

  OrderPayment({
    this.id,
    this.orderId,
    this.paymentType,
    this.paidAmount,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentTime,
  });

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'],
      orderId: json['order_id'],
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
      'order_id': orderId,
      'payment_type': paymentType,
      'paid_amount': paidAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_time': paymentTime,
    };
  }
}