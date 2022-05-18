// To parse this JSON data, do
//
//     final finixResponse = finixResponseFromJson(jsonString);

import 'dart:convert';

FinixResponse finixResponseFromJson(String str) => FinixResponse.fromJson(json.decode(str));

String finixResponseToJson(FinixResponse data) => json.encode(data.toJson());

class FinixResponse {
  FinixResponse({
    this.merchantName,
    this.merchantAddress,
    this.applicationLabel,
    this.applicationIdentifier,
    this.merchantId,
    this.referenceNumber,
    this.accountNumber,
    this.cardBrand,
    this.entryMode,
    this.transactionId,
    this.approvalCode,
    this.responseCode,
    this.responseMessage,
    this.cryptogram,
    this.transactionType,
    this.date,
    this.transferId,
    this.traceId,
    this.transferState,
    this.amount,
    this.created,
    this.updated,
    this.resourceTags,
    this.maskedAccountNumber,
    this.cardLogo,
    this.cardHolderName,
    this.expirationMonth,
    this.expirationYear,
  });

  String? merchantName;
  String? merchantAddress;
  String? applicationLabel;
  String? applicationIdentifier;
  String? merchantId;
  String? referenceNumber;
  String? accountNumber;
  String? cardBrand;
  String? entryMode;
  String? transactionId;
  String? approvalCode;
  String? responseCode;
  String? responseMessage;
  String? cryptogram;
  String? transactionType;
  String? date;
  String? transferId;
  String? traceId;
  String? transferState;
  double? amount;
  String? created;
  String? updated;
  List<ResourceTag>? resourceTags;
  String? maskedAccountNumber;
  String? cardLogo;
  String? cardHolderName;
  String? expirationMonth;
  String? expirationYear;

  factory FinixResponse.fromJson(Map<String, dynamic> json) => FinixResponse(
    merchantName: json["merchantName"],
    merchantAddress: json["merchantAddress"],
    applicationLabel: json["applicationLabel"],
    applicationIdentifier: json["applicationIdentifier"],
    merchantId: json["merchantId"],
    referenceNumber: json["referenceNumber"],
    accountNumber: json["accountNumber"],
    cardBrand: json["cardBrand"],
    entryMode: json["entryMode"],
    transactionId: json["transactionId"],
    approvalCode: json["approvalCode"],
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
    cryptogram: json["cryptogram"],
    transactionType: json["transactionType"],
    date: json["date"].toString(),
    transferId: json["transferId"],
    traceId: json["traceId"],
    transferState: json["transferState"],
    amount: json["amount"],
    created: json["created"].toString(),
    updated: json["updated"].toString(),
    resourceTags: List<ResourceTag>.from(json["resourceTags"].map((x) => ResourceTag.fromJson(x))),
    maskedAccountNumber: json["maskedAccountNumber"],
    cardLogo: json["cardLogo"],
    cardHolderName: json["cardHolderName"],
    expirationMonth: json["expirationMonth"],
    expirationYear: json["expirationYear"],
  );

  Map<String, dynamic> toJson() => {
    "merchantName": merchantName,
    "merchantAddress": merchantAddress,
    "applicationLabel": applicationLabel,
    "applicationIdentifier": applicationIdentifier,
    "merchantId": merchantId,
    "referenceNumber": referenceNumber,
    "accountNumber": accountNumber,
    "cardBrand": cardBrand,
    "entryMode": entryMode,
    "transactionId": transactionId,
    "approvalCode": approvalCode,
    "responseCode": responseCode,
    "responseMessage": responseMessage,
    "cryptogram": cryptogram,
    "transactionType": transactionType,
    "date": date,
    "transferId": transferId,
    "traceId": traceId,
    "transferState": transferState,
    "amount": amount,
    "created": created,
    "updated": updated,
    "resourceTags": List<dynamic>.from(resourceTags!.map((x) => x.toJson())),
    "maskedAccountNumber": maskedAccountNumber,
    "cardLogo": cardLogo,
    "cardHolderName": cardHolderName,
    "expirationMonth": expirationMonth,
    "expirationYear": expirationYear,
  };
}

class ResourceTag {
  ResourceTag({
    this.orderNumber,
    this.test,
  });

  String? orderNumber;
  String? test;

  factory ResourceTag.fromJson(Map<String, dynamic> json) => ResourceTag(
    orderNumber: json["order_number"],
    test: json["Test"],
  );

  Map<String, dynamic> toJson() => {
    "order_number": orderNumber,
    "Test": test,
  };
}
