// To parse this JSON data, do
//
//     final finixMannualPayModel = finixMannualPayModelFromJson(jsonString);

import 'dart:convert';

FinixMannualPayModel finixMannualPayModelFromJson(String str) => FinixMannualPayModel.fromJson(json.decode(str));

String finixMannualPayModelToJson(FinixMannualPayModel data) => json.encode(data.toJson());

class FinixMannualPayModel {
  FinixMannualPayModel({
    this.paymentMethod,
    this.orderId,
    this.stripePaymentMethodId,
    this.stripeCardId,
    this.finixResponseDto,
    this.finixNcPaymentToken,
    this.finixNcpMerchantId,
    this.phoneNumber,
  });

  String? paymentMethod;
  String? orderId;
  dynamic stripePaymentMethodId;
  dynamic stripeCardId;
  dynamic finixResponseDto;
  String? finixNcPaymentToken;
  String? finixNcpMerchantId;
  String? phoneNumber;

  factory FinixMannualPayModel.fromJson(Map<String, dynamic> json) => FinixMannualPayModel(
    paymentMethod: json["paymentMethod"],
    orderId: json["orderId"],
    stripePaymentMethodId: json["stripePaymentMethodId"],
    stripeCardId: json["stripeCardId"],
    finixResponseDto: json["finixResponseDto"],
    finixNcPaymentToken: json["finixNCPaymentToken"],
    finixNcpMerchantId: json["finixNCPMerchantId"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "paymentMethod": paymentMethod,
    "orderId": orderId,
    "stripePaymentMethodId": stripePaymentMethodId,
    "stripeCardId": stripeCardId,
    "finixResponseDto": finixResponseDto,
    "finixNCPaymentToken": finixNcPaymentToken,
    "finixNCPMerchantId": finixNcpMerchantId,
    "phoneNumber": phoneNumber,
  };
}
