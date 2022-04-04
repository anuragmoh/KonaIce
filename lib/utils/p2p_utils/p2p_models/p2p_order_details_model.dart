import 'dart:convert';

import 'package:kona_ice_pos/models/network_model/order_model/order_request_model.dart';

P2POrderDetailsModel p2POrderDetailsModelFromJson(String str) => P2POrderDetailsModel.fromJson(json.decode(str));

String p2POrderDetailsModelToJson(P2POrderDetailsModel data) => json.encode(data.toJson());

class P2POrderDetailsModel {
  P2POrderDetailsModel({
    this.tip,
    this.discount,
    this.totalAmount,
    this.foodCost,
    this.salesTax,
    this.orderRequestModel,
  });

  double? tip;
  double? discount;
  double? totalAmount;
  double? foodCost;
  double? salesTax;
  PlaceOrderRequestModel? orderRequestModel;

  factory P2POrderDetailsModel.fromJson(Map<String, dynamic> json) => P2POrderDetailsModel(
    tip: json["tip"],
    discount: json["discount"],
    totalAmount: json["totalAmount"],
    foodCost: json["foodCost"],
    salesTax: json["salesTax"],
    orderRequestModel: PlaceOrderRequestModel.fromJson(json["orderRequestModel"]),
  );

  Map<String, dynamic> toJson() => {
    "tip": tip,
    "discount": discount,
    "totalAmount": totalAmount,
    "foodCost": foodCost,
    "salesTax": salesTax,
    "orderRequestModel": orderRequestModel!.toJson(),
  };
}
