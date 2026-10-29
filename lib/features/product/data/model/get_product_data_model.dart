// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class getProductDataModel {
  int? id;
  String? name;
  String? stock_price;
  String? barcode;
  String? description;
  int? tax;
  int? gst;
  String? mrp;
  String? hsn;
  int? product_category_id;
  String? product_category;

  int? item_type_id;
  double? selectedQty;
  String? type;
  String? brand_name;
  String? model_name;
  String? itemCode;
  dynamic base_price;


  getProductDataModel({
    this.id,
    this.itemCode,
    this.name,
    this.stock_price,
    this.barcode,
    this.description,
    this.tax,
    this.gst,
    this.mrp,
    this.hsn,
    this.product_category_id,
    this.product_category,

    this.item_type_id,
    this.selectedQty,
    this.type,
    this.brand_name,
    this.model_name,
    this.base_price
  });
  

  // getProductDataModel copyWith({
  //   int? id,
  //   String? name,
  //   String? stock_price,
  //   String? barcode,
  //   String? description,
  //   int? tax,
  //   int? gst,
  //   String? mrp,
  //   String? hsn,
  //   int? product_category_id,
  //   int? item_type_id,
  //   double? selectedQty,
  //   String? type;
  //   String? brand_name;
  //   String? model_name;
  // }) {
  //   return getProductDataModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     stock_price: stock_price ?? this.stock_price,
  //     barcode: barcode ?? this.barcode,
  //     description: description ?? this.description,
  //     tax: tax ?? this.tax,
  //     gst: gst ?? this.gst,
  //     mrp: mrp ?? this.mrp,
  //     hsn: hsn ?? this.hsn,
  //     product_category_id: product_category_id ?? this.product_category_id,
  //     item_type_id: item_type_id ?? this.item_type_id,
  //     selectedQty: selectedQty ?? this.selectedQty,
  //       String? type;
  //       String? brand_name;
  //       String? model_name;
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'itemCode':itemCode,
      'stock_price': stock_price,
      'barcode': barcode,
      'description': description,
      'tax': tax,
      'gst': gst,
      'mrp': mrp,
      'hsn': hsn,
      'product_category_id': product_category_id,
      'product_category': product_category,

      'item_type_id': item_type_id,
      'selectedQty': selectedQty,
      'type': type,
      'brand_name': brand_name,
      'model_name': model_name,
      'base_price':base_price,

    };
  }

  factory getProductDataModel.fromMap(Map<String, dynamic> map) {
    return getProductDataModel(
      id: map['id'] != null ? map['id'] as int : null,

      itemCode: map['item_no'] != null ? map['item_no'] as String : null,

      name: map['name'] != null ? map['name'] as String : null,
      stock_price: map['stock_price'] != null ? map['stock_price'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      tax: map['tax'] != null ? map['tax'] as int : null,
      gst: map['gst'] != null ? map['gst'] as int : null,
      mrp: map['mrp'] != null ? map['mrp'] as String : null,
      hsn: map['hsn'] != null ? map['hsn'] as String : null,
      product_category_id: map['product_category_id'] != null ? map['product_category_id'] as int : null,
      product_category: map['product_category'] != null ? map['product_category'] as String : null,

      item_type_id: map['item_type_id'] != null ? map['item_type_id'] as int : null,
      selectedQty: map['selectedQty'] != null ? map['selectedQty'] as double : null,
        type: map['type'] != null ? map['type'] as String : null,
        brand_name: map['brand_name'] != null ? map['brand_name'] as String : null,
        model_name: map['model_name'] != null ? map['model_name'] as String : null,
       base_price: map['base_price'] != null ? map['base_price'] as dynamic : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory getProductDataModel.fromJson(String source) => getProductDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'getProductDataModel(id: $id, name: $name, stock_price: $stock_price, barcode: $barcode, description: $description, tax: $tax, mrp: $mrp, hsn: $hsn, product_category_id: $product_category_id, item_type_id: $item_type_id, selectedQty: $selectedQty, base_price:$base_price)';
  }

  @override
  bool operator ==(covariant getProductDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.stock_price == stock_price &&
      other.barcode == barcode &&
      other.description == description &&
      other.tax == tax &&
      other.gst == gst &&
      other.mrp == mrp &&
      other.hsn == hsn &&
      other.product_category_id == product_category_id &&
      other.item_type_id == item_type_id &&
      other.selectedQty == selectedQty  &&
     other.base_price == base_price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      stock_price.hashCode ^
      barcode.hashCode ^
      description.hashCode ^
      tax.hashCode ^
      gst.hashCode ^
      mrp.hashCode ^
      hsn.hashCode ^
      product_category_id.hashCode ^
      item_type_id.hashCode ^
      selectedQty.hashCode ^
      base_price.hashCode ;
  }
}
