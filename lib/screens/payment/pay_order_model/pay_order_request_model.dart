
import 'dart:convert';

PayOrderRequestModel payOrderRequestModelFromJson(String str) => PayOrderRequestModel.fromJson(json.decode(str));

String payOrderRequestModelToJson(PayOrderRequestModel data) => json.encode(data.toJson());

class PayOrderRequestModel {
  PayOrderRequestModel({
    this.paymentMethod,
    this.cardId,
    this.orderId,
  });

  String? paymentMethod;
  String? cardId;
  String? orderId;

  factory PayOrderRequestModel.fromJson(Map<String, dynamic> json) => PayOrderRequestModel(
    paymentMethod: json["paymentMethod"],
    cardId: json["cardId"],
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "paymentMethod": paymentMethod,
    "cardId": cardId,
    "orderId": orderId,
  };
}
