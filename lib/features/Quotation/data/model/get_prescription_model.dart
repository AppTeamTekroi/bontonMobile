// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? num.tryParse(value.toString())?.toInt();
}

class GetCustomerPrescriptionModel {
  int? id;
  String? customer_id;
  int? l_sph;
  int? l_cyl;
  int? l_axis;
  int? l_vision;
  int? r_sph;
  int? r_cyl;
  int? r_axis;
  int? r_vision;
  int? add;
  int? pd;
  String? optometrics;
  GetCustomerPrescriptionModel({
    this.id,
    this.customer_id,
    this.l_sph,
    this.l_cyl,
    this.l_axis,
    this.l_vision,
    this.r_sph,
    this.r_cyl,
    this.r_axis,
    this.r_vision,
    this.add,
    this.pd,
    this.optometrics,
  });

  GetCustomerPrescriptionModel copyWith({
    int? id,
    String? customer_id,
    int? l_sph,
    int? l_cyl,
    int? l_axis,
    int? l_vision,
    int? r_sph,
    int? r_cyl,
    int? r_axis,
    int? r_vision,
    int? add,
    int? pd,
    String? optometrics,
  }) {
    return GetCustomerPrescriptionModel(
      id: id ?? this.id,
      customer_id: customer_id ?? this.customer_id,
      l_sph: l_sph ?? this.l_sph,
      l_cyl: l_cyl ?? this.l_cyl,
      l_axis: l_axis ?? this.l_axis,
      l_vision: l_vision ?? this.l_vision,
      r_sph: r_sph ?? this.r_sph,
      r_cyl: r_cyl ?? this.r_cyl,
      r_axis: r_axis ?? this.r_axis,
      r_vision: r_vision ?? this.r_vision,
      add: add ?? this.add,
      pd: pd ?? this.pd,
      optometrics: optometrics ?? this.optometrics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_id': customer_id,
      'l_sph': l_sph,
      'l_cyl': l_cyl,
      'l_axis': l_axis,
      'l_vision': l_vision,
      'r_sph': r_sph,
      'r_cyl': r_cyl,
      'r_axis': r_axis,
      'r_vision': r_vision,
      'add': add,
      'pd': pd,
      'optometrics': optometrics,
    };
  }

  factory GetCustomerPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return GetCustomerPrescriptionModel(
      id: _asInt(map['id']),
      customer_id: map['customer_id']?.toString(),
      l_sph: _asInt(map['l_sph']),
      l_cyl: _asInt(map['l_cyl']),
      l_axis: _asInt(map['l_axis']),
      l_vision: _asInt(map['l_vision']),
      r_sph: _asInt(map['r_sph']),
      r_cyl: _asInt(map['r_cyl']),
      r_axis: _asInt(map['r_axis']),
      r_vision: _asInt(map['r_vision']),
      add: _asInt(map['add']),
      pd: _asInt(map['pd']),
      optometrics: map['optometrics']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCustomerPrescriptionModel.fromJson(String source) => GetCustomerPrescriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetCustomerPrescriptionModel(id: $id, customer_id: $customer_id, l_sph: $l_sph, l_cyl: $l_cyl, l_axis: $l_axis, l_vision: $l_vision, r_sph: $r_sph, r_cyl: $r_cyl, r_axis: $r_axis, r_vision: $r_vision, add: $add, pd: $pd, optometrics: $optometrics)';
  }

  @override
  bool operator ==(covariant GetCustomerPrescriptionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.customer_id == customer_id &&
      other.l_sph == l_sph &&
      other.l_cyl == l_cyl &&
      other.l_axis == l_axis &&
      other.l_vision == l_vision &&
      other.r_sph == r_sph &&
      other.r_cyl == r_cyl &&
      other.r_axis == r_axis &&
      other.r_vision == r_vision &&
      other.add == add &&
      other.pd == pd &&
      other.optometrics == optometrics;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      customer_id.hashCode ^
      l_sph.hashCode ^
      l_cyl.hashCode ^
      l_axis.hashCode ^
      l_vision.hashCode ^
      r_sph.hashCode ^
      r_cyl.hashCode ^
      r_axis.hashCode ^
      r_vision.hashCode ^
      add.hashCode ^
      pd.hashCode ^
      optometrics.hashCode;
  }
}
