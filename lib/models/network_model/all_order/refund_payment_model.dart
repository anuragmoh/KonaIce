// To parse this JSON data, do
//
//     final refundPaymentModel = refundPaymentModelFromJson(jsonString);

import 'dart:convert';

RefundPaymentModel refundPaymentModelFromJson(String str) => RefundPaymentModel.fromJson(json.decode(str));

String refundPaymentModelToJson(RefundPaymentModel data) => json.encode(data.toJson());

class RefundPaymentModel {
  RefundPaymentModel({
    this.refundAmount,
  });

  double? refundAmount;

  factory RefundPaymentModel.fromJson(Map<String, dynamic> json) => RefundPaymentModel(
    refundAmount: json["refundAmount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "refundAmount": refundAmount,
  };
}
