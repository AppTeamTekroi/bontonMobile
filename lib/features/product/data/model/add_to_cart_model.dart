// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddToCartModel {
  String? productId;
  String? customerId;
  String? quantities;
  var basePrice;
  AddToCartModel({
    this.productId,
    this.customerId,
    this.quantities,
    this.basePrice
  });

  AddToCartModel copyWith({
    String? productId,
    String? customerId,
    String? quantities,
    var basePrice
  }) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      customerId: customerId ?? this.customerId,
      quantities: quantities ?? this.quantities,
      basePrice: basePrice ?? this.basePrice
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'customerId': customerId,
      'quantities': quantities,
      'basePrice': basePrice,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      customerId: map['customerId'] != null ? map['customerId'] as String : null,
      quantities: map['quantities'] != null ? map['quantities'] as String : null,
      basePrice : map['basePrice']  != null ? map['basePrice'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddToCartModel.fromJson(String source) => AddToCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddToCartModel(productId: $productId, customerId: $customerId, quantities: $quantities, basePrice: $basePrice)';

  @override
  bool operator ==(covariant AddToCartModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.productId == productId &&
      other.customerId == customerId &&
      other.quantities == quantities &&
      other.basePrice == basePrice;

  }

  @override
  int get hashCode => productId.hashCode ^ customerId.hashCode ^ quantities.hashCode ^ basePrice.hashCode;
}
