// To parse this JSON data, do
//
//     final stripTokenRequestModel = stripTokenRequestModelFromJson(jsonString);

import 'dart:convert';

StripTokenResponseModel stripTokenResponseModelFromJson(String str) =>
    StripTokenResponseModel.fromJson(json.decode(str));

String stripTokenResponseModelToJson(StripTokenResponseModel data) =>
    json.encode(data.toJson());

class StripTokenResponseModel {
  StripTokenResponseModel({
    this.id,
    this.object,
    this.card,
    this.clientIp,
    this.created,
    this.livemode,
    this.type,
    this.used,
  });

  String? id;
  String? object;
  Card? card;
  String? clientIp;
  int? created;
  bool? livemode;
  String? type;
  bool? used;

  factory StripTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      StripTokenResponseModel(
        id: json["id"],
        object: json["object"],
        card: Card.fromJson(json["card"]),
        clientIp: json["client_ip"],
        created: json["created"],
        livemode: json["livemode"],
        type: json["type"],
        used: json["used"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "card": card!.toJson(),
        "client_ip": clientIp,
        "created": created,
        "livemode": livemode,
        "type": type,
        "used": used,
      };
}

class Card {
  Card({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.funding,
    this.last4,
    this.name,
    this.tokenizationMethod,
  });

  String? id;
  String? object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String? brand;
  String? country;
  String? cvcCheck;
  dynamic dynamicLast4;
  int? expMonth;
  int? expYear;
  String? funding;
  String? last4;
  dynamic name;
  dynamic tokenizationMethod;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        object: json["object"],
        addressCity: json["address_city"],
        addressCountry: json["address_country"],
        addressLine1: json["address_line1"],
        addressLine1Check: json["address_line1_check"],
        addressLine2: json["address_line2"],
        addressState: json["address_state"],
        addressZip: json["address_zip"],
        addressZipCheck: json["address_zip_check"],
        brand: json["brand"],
        country: json["country"],
        cvcCheck: json["cvc_check"],
        dynamicLast4: json["dynamic_last4"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        funding: json["funding"],
        last4: json["last4"],
        name: json["name"],
        tokenizationMethod: json["tokenization_method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "address_city": addressCity,
        "address_country": addressCountry,
        "address_line1": addressLine1,
        "address_line1_check": addressLine1Check,
        "address_line2": addressLine2,
        "address_state": addressState,
        "address_zip": addressZip,
        "address_zip_check": addressZipCheck,
        "brand": brand,
        "country": country,
        "cvc_check": cvcCheck,
        "dynamic_last4": dynamicLast4,
        "exp_month": expMonth,
        "exp_year": expYear,
        "funding": funding,
        "last4": last4,
        "name": name,
        "tokenization_method": tokenizationMethod,
      };
}
