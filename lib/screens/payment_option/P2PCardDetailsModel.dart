
import 'dart:convert';

P2PCardDetailsModel p2PCardDetailsModelFromJson(String str) => P2PCardDetailsModel.fromJson(json.decode(str));

String p2PCardDetailsModelToJson(P2PCardDetailsModel data) => json.encode(data.toJson());

class P2PCardDetailsModel {
  P2PCardDetailsModel({
    this.cardNumber,
    this.cardCvc,
    this.cardExpiryYear,
    this.cardExpiryMonth,
  });

  String? cardNumber;
  String? cardCvc;
  String? cardExpiryYear;
  String? cardExpiryMonth;

  factory P2PCardDetailsModel.fromJson(Map<String, dynamic> json) => P2PCardDetailsModel(
    cardNumber: json["cardNumber"],
    cardCvc: json["cardCvc"],
    cardExpiryYear: json["cardExpiryYear"],
    cardExpiryMonth: json["cardExpiryMonth"],
  );

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "cardCvc": cardCvc,
    "cardExpiryYear": cardExpiryYear,
    "cardExpiryMonth": cardExpiryMonth,
  };
}