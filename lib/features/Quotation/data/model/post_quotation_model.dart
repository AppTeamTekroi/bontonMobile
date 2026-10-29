// class PostQuotationModel {
//   int? customerId;
//   int? userId;
//   int? storeId;
//   double? amount;
//   String? discount;
//
//   int? paymentType;
//   int? paymentSettlement;
//   String? lSph;
//   String? lCyl;
//   String? lAxis;
//   String? lVision;
//   String? rSph;
//   String? rCyl;
//   String? rAxis;
//   String? rVision;
//   String? add;
//   String? pd;
//   String? optometrics;
//   double? paidAmount;
//   double? totalTax;
//   double? amounttopay;
//
//   PostQuotationModel(
//       {this.customerId,
//         this.userId,
//         this.storeId,
//         this.paymentType,
//         this.amount,
//         // this.totalTax,
//         // this.amounttopay,
//         this.discount,
//         this.paymentSettlement,
//         this.lSph,
//         this.lCyl,
//         this.lAxis,
//         this.lVision,
//         this.rSph,
//         this.rCyl,
//         this.rAxis,
//         this.rVision,
//         this.add,
//         this.pd,
//         this.optometrics,
//         this.paidAmount,
//         this.amounttopay,
//         this.totalTax, required String discount_type
//       });
//
//   PostQuotationModel.fromJson(Map<String, dynamic> json) {
//     customerId = json['customerId'];
//     userId = json['userId'];
//     storeId = json['store_id'];
//     // paymentType = json['paymentType'];
//     amount = json['amount'];
//     discount = json['discount'];
//     totalTax = json['total_tax'];
//     amounttopay = json['amount_to_pay'];
//     paymentType = json['payment_type'];
//     paymentSettlement = json['payment_settlement'];
//     lSph = json['l_sph'];
//     lCyl = json['l_cyl'];
//     lAxis = json['l_axis'];
//     lVision = json['l_vision'];
//     rSph = json['r_sph'];
//     rCyl = json['r_cyl'];
//     rAxis = json['r_axis'];
//     rVision = json['r_vision'];
//     add = json['add'];
//     pd = json['pd'];
//     optometrics = json['optometrics'];
//     paidAmount = json['paid_amount'];
//     amount = json['amount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['customerId'] = this.customerId;
//     data['userId'] = this.userId;
//     data['store_id'] = this.storeId;
//     //data['paymentType'] = this.paymentType;
//     data['amount'] = this.amount;
//     data['discount'] = this.discount;
//     data['amount_to_pay'] = this.amounttopay;
//     data['total_tax'] = this.totalTax;
//     data['payment_type'] = this.paymentType;
//     data['payment_settlement'] = this.paymentSettlement;
//     data['l_sph'] = this.lSph;
//     data['l_cyl'] = this.lCyl;
//     data['l_axis'] = this.lAxis;
//     data['l_vision'] = this.lVision;
//     data['r_sph'] = this.rSph;
//     data['r_cyl'] = this.rCyl;
//     data['r_axis'] = this.rAxis;
//     data['r_vision'] = this.rVision;
//     data['add'] = this.add;
//     data['pd'] = this.pd;
//     data['optometrics'] = this.optometrics;
//     data['paid_amount'] = this.paidAmount;
//     data['amount'] = this.amount;
//     return data;
//   }
// }