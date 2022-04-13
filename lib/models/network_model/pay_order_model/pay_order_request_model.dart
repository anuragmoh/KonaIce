
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


PayOrderCardRequestModel payOrderCardRequestModelFromJson(String str) => PayOrderCardRequestModel.fromJson(json.decode(str));

String payOrderCardRequestModelToJson(PayOrderCardRequestModel data) => json.encode(data.toJson());

class PayOrderCardRequestModel {
  PayOrderCardRequestModel({
    this.paymentMethod,
    this.stripePaymentMethodId,
    this.stripeCardId,
    this.orderId,
  });

  String? paymentMethod;
  String? stripePaymentMethodId;
  String? stripeCardId;
  String? orderId;

  factory PayOrderCardRequestModel.fromJson(Map<String, dynamic> json) => PayOrderCardRequestModel(
    paymentMethod: json["paymentMethod"],
    stripePaymentMethodId: json["stripePaymentMethodId"],
    stripeCardId: json["stripeCardId"],
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "paymentMethod": paymentMethod,
    "stripePaymentMethodId": stripePaymentMethodId,
    "stripeCardId": stripeCardId,
    "orderId": orderId,
  };
}
