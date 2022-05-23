// To parse this JSON data, do
//
//     final FinixResponseModel = finixResponseFromJson(jsonString);

import 'dart:convert';

FinixResponseModel finixResponseFromJson(String str) => FinixResponseModel.fromJson(json.decode(str));

String finixResponseToJson(FinixResponseModel data) => json.encode(data.toJson());

class FinixResponseModel {
  FinixResponseModel({
    this.finixSaleResponse,
    this.finixSaleReceipt,
  });

  FinixSaleResponse? finixSaleResponse;
  FinixSaleReceipt? finixSaleReceipt;

  factory FinixResponseModel.fromJson(Map<String, dynamic> json) => FinixResponseModel(
    finixSaleResponse: FinixSaleResponse.fromJson(json["finixSaleResponse"]),
    finixSaleReceipt: FinixSaleReceipt.fromJson(json["finixSaleReceipt"]),
  );

  Map<String, dynamic> toJson() => {
    "finixSaleResponse": finixSaleResponse!.toJson(),
    "finixSaleReceipt": finixSaleReceipt!.toJson(),
  };
}

class FinixSaleReceipt {
  FinixSaleReceipt({
    this.cryptogram,
    this.merchantId,
    this.accountNumber,
    this.referenceNumber,
    this.applicationLabel,
    this.entryMode,
    this.approvalCode,
    this.transactionId,
    this.cardBrand,
    this.merchantName,
    this.merchantAddress,
    this.responseCode,
    this.transactionType,
    this.responseMessage,
    this.applicationIdentifier,
    this.date,
  });

  String? cryptogram;
  String? merchantId;
  String? accountNumber;
  String? referenceNumber;
  String? applicationLabel;
  String? entryMode;
  String? approvalCode;
  String? transactionId;
  String? cardBrand;
  String? merchantName;
  String? merchantAddress;
  String? responseCode;
  String? transactionType;
  String? responseMessage;
  String? applicationIdentifier;
  dynamic date;

  factory FinixSaleReceipt.fromJson(Map<String, dynamic> json) => FinixSaleReceipt(
    cryptogram: json["cryptogram"],
    merchantId: json["merchantId"],
    accountNumber: json["accountNumber"],
    referenceNumber: json["referenceNumber"],
    applicationLabel: json["applicationLabel"],
    entryMode: json["entryMode"],
    approvalCode: json["approvalCode"],
    transactionId: json["transactionId"],
    cardBrand: json["cardBrand"],
    merchantName: json["merchantName"],
    merchantAddress: json["merchantAddress"],
    responseCode: json["responseCode"],
    transactionType: json["transactionType"],
    responseMessage: json["responseMessage"],
    applicationIdentifier: json["applicationIdentifier"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "cryptogram": cryptogram,
    "merchantId": merchantId,
    "accountNumber": accountNumber,
    "referenceNumber": referenceNumber,
    "applicationLabel": applicationLabel,
    "entryMode": entryMode,
    "approvalCode": approvalCode,
    "transactionId": transactionId,
    "cardBrand": cardBrand,
    "merchantName": merchantName,
    "merchantAddress": merchantAddress,
    "responseCode": responseCode,
    "transactionType": transactionType,
    "responseMessage": responseMessage,
    "applicationIdentifier": applicationIdentifier,
    "date": date,
  };
}

class FinixSaleResponse {
  FinixSaleResponse({
    this.transferId,
    this.updated,
    this.amount,
    this.cardLogo,
    this.cardHolderName,
    this.expirationMonth,
    this.resourceTags,
    this.entryMode,
    this.maskedAccountNumber,
    this.created,
    this.traceId,
    this.transferState,
    this.expirationYear,
  });

  String? transferId;
  double? updated;
  dynamic amount;
  String? cardLogo;
  String? cardHolderName;
  String? expirationMonth;
  ResourceTags? resourceTags;
  String? entryMode;
  String? maskedAccountNumber;
  double? created;
  String? traceId;
  String? transferState;
  String? expirationYear;

  factory FinixSaleResponse.fromJson(Map<String, dynamic> json) => FinixSaleResponse(
    transferId: json["transferId"],
    updated: json["updated"].toDouble(),
    amount: json["amount"],
    cardLogo: json["cardLogo"],
    cardHolderName: json["cardHolderName"],
    expirationMonth: json["expirationMonth"],
    resourceTags: ResourceTags.fromJson(json["resourceTags"]),
    entryMode: json["entryMode"],
    maskedAccountNumber: json["maskedAccountNumber"],
    created: json["created"].toDouble(),
    traceId: json["traceId"],
    transferState: json["transferState"],
    expirationYear: json["expirationYear"],
  );

  Map<String, dynamic> toJson() => {
    "transferId": transferId,
    "updated": updated,
    "amount": amount,
    "cardLogo": cardLogo,
    "cardHolderName": cardHolderName,
    "expirationMonth": expirationMonth,
    "resourceTags": resourceTags!.toJson(),
    "entryMode": entryMode,
    "maskedAccountNumber": maskedAccountNumber,
    "created": created,
    "traceId": traceId,
    "transferState": transferState,
    "expirationYear": expirationYear,
  };
}

class ResourceTags {
  ResourceTags({
    this.test,
    this.orderNumber,
  });

  String? test;
  String? orderNumber;

  factory ResourceTags.fromJson(Map<String, dynamic> json) => ResourceTags(
    test: json["Test"],
    orderNumber: json["order_number"],
  );

  Map<String, dynamic> toJson() => {
    "Test": test,
    "order_number": orderNumber,
  };
}

