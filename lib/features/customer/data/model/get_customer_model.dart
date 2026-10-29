class CustomersModel {
  int? id;
  String? company_name;
  String? email;
  String? gstin;
  String? gstStatus;
  String? name;
  String? cardCode;
  String? phone;
  String? whatsAppNumber;
  String? phone1;
  String? phone2;
  int? openingBalance;
  int? creditCustomer;
  int? orders_count;
  String? invoiceTotal;
  int? store_id;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? lastInvoice;
  List<GetAddressModel>? address;

  CustomersModel({
    this.id,
    this.company_name,
    this.email,
    this.gstin,
    this.gstStatus,
    this.name,
    this.cardCode,
    this.phone,
    this.whatsAppNumber,
    this.phone1,
    this.phone2,
    this.openingBalance,
    this.creditCustomer,
    this.orders_count,
    this.invoiceTotal,
    this.store_id,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.lastInvoice,
    this.address,
  });

  factory CustomersModel.fromMap(Map<String, dynamic> map) {
    return CustomersModel(
      id: map['id'],
      company_name: map['company_name'],
      email: map['email'],
      gstin: map['gstin'],
      gstStatus: map['gst_status'],
      name: map['name'],
      cardCode: map['card_code'],
      phone: map['phone']?.toString(),
      whatsAppNumber: map['whats_app_number']?.toString(),
      phone1: map['phone_1']?.toString(),
      phone2: map['phone_2']?.toString(),

      openingBalance: int.tryParse(map['opening_balance'].toString()),
      creditCustomer: int.tryParse(map['credit_customer'].toString()),
      orders_count: int.tryParse(map['orders_count'].toString()),

      invoiceTotal: map['invoice_total']?.toString(),
      lastInvoice: map['last_invoice_total']?.toString(),

      store_id: int.tryParse(map['store_id'].toString()),

      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      status: int.tryParse(map['status'].toString()),

      address: map['address'] != null
          ? List<GetAddressModel>.from(
        map['address'].map((x) => GetAddressModel.fromMap(x)),
      )
          : null,
    );
  }
}
class GetAddressModel {
  int? id;
  String? customerId;
  String? type;
  String? address_1;
  String? address_2;
  String? isBilling;
  String? isShipping;
  String? city;
  String? pincode;
  String? state;
  String? isSame;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? customerVendorId;

  GetAddressModel({
    this.id,
    this.customerId,
    this.type,
    this.address_1,
    this.address_2,
    this.isBilling,
    this.isShipping,
    this.city,
    this.pincode,
    this.state,
    this.isSame,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.customerVendorId,
  });

  factory GetAddressModel.fromMap(Map<String, dynamic> map) {
    return GetAddressModel(
      id: map['id'],
      customerId: map['customer_id']?.toString(),
      type: map['type'],
      address_1: map['address_1'],
      address_2: map['address_2'],
      isBilling: map['is_billing']?.toString(),
      isShipping: map['is_shipping']?.toString(),
      city: map['city'],
      pincode: map['pincode']?.toString(),
      state: map['state'],
      isSame: map['is_same']?.toString(),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      status: int.tryParse(map['status'].toString()),
      customerVendorId: map['customer_vendor_id']?.toString(),
    );
  }
}
