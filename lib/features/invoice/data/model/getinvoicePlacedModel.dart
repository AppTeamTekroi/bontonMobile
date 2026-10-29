class GetInvoicePlacedModel {
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
  List<invoicePayments>? invoicepayments;
  Customer? customer;

  GetInvoicePlacedModel(
      {

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
        this.invoicepayments,
        this.customer

      });

  GetInvoicePlacedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    prescriptionId = json['prescription_id'];
    totalAmount = json['total_amount'];
    amount = json['amount'];
    totalGst = json['total_gst'];
    advanceAmount = json['advance_amount'];
    discount = json['discount'];
    paymentType = json['payment_type'];
    paymentSettlement = json['payment_settlement'];
    paidAmount = json['paid_amount'];
    invoiceStatus = json['invoice_status'];
    storeId = json['store_id'];
    strinvoiceSeries = json['str_invoice_series'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    paymentMethods = json['payment_methods'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    if (json['invoicepayments'] != null) {
      invoicepayments = <invoicePayments>[];
      json['invoicepayments'].forEach((v) {
        invoicepayments!.add(invoicePayments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['customer_id'] = customerId;
    data['prescription_id'] = prescriptionId;
    data['total_amount'] = totalAmount;
    data['amount'] = amount;
    data['total_gst'] = totalGst;
    data['advance_amount'] = advanceAmount;
    data['discount'] = discount;
    data['payment_type'] = paymentType;
    data['payment_settlement'] = paymentSettlement;
    data['paid_amount'] = paidAmount;
    data['invoice_status'] = invoiceStatus;
    data['store_id'] = storeId;
    data['str_invoice_series'] = strinvoiceSeries;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['payment_methods'] = paymentMethods;
    if (invoicepayments != null) {
      data['invoicepayments'] =
          invoicepayments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class invoicePayments {
  int? id;
  int? invoiceId;
  String? paymentType;
  num? paidAmount;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? paymentTime;

  invoicePayments(
      {this.id,
        this.invoiceId,
        this.paymentType,
        this.paidAmount,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.paymentTime});

  invoicePayments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceId = json['invoice_id'];
    paymentType = json['payment_type'];
    paidAmount =  json['paid_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    paymentTime = json['payment_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['invoice_id'] = invoiceId;
    data['payment_type'] = paymentType;
    data['paid_amount'] = paidAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['payment_time'] = paymentTime;
    return data;
  }
}

class Customer {
  int? id;
  String? companyName;
  String? email;
  String? gstin;
  String? name;
  String? phone;
  int? openingBalance;
  int? addressId;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  int? status;

  Customer(
      {this.id,
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
        this.status});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    email = json['email'];
    gstin = json['gstin'];
    name = json['name'];
    phone = json['phone'];
    openingBalance = json['opening_balance'];
    addressId = json['address_id'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['email'] = email;
    data['gstin'] = gstin;
    data['name'] = name;
    data['phone'] = phone;
    data['opening_balance'] = openingBalance;
    data['address_id'] = addressId;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}

