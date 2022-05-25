// To parse this JSON data, do
//
//     final payReceipt = payReceiptFromJson(jsonString);

import 'dart:convert';

PayReceipt payReceiptFromJson(String str) =>
    PayReceipt.fromJson(json.decode(str));

String payReceiptToJson(PayReceipt data) => json.encode(data.toJson());

class PayReceipt {
  PayReceipt({
    this.paymentMethod,
    this.orderId,
    this.stripePaymentMethodId,
    this.stripeCardId,
    this.finixResponseDto,
  });

  String? paymentMethod;
  String? orderId;
  dynamic stripePaymentMethodId;
  dynamic stripeCardId;
  FinixResponseDto? finixResponseDto;

  factory PayReceipt.fromJson(Map<String, dynamic> json) => PayReceipt(
        paymentMethod: json["paymentMethod"],
        orderId: json["orderId"],
        stripePaymentMethodId: json["stripePaymentMethodId"],
        stripeCardId: json["stripeCardId"],
        finixResponseDto: FinixResponseDto.fromJson(json["finixResponseDto"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethod": paymentMethod,
        "orderId": orderId,
        "stripePaymentMethodId": stripePaymentMethodId,
        "stripeCardId": stripeCardId,
        "finixResponseDto": finixResponseDto!.toJson(),
      };
}

class FinixResponseDto {
  FinixResponseDto({
    this.finixSaleResponse,
    this.finixSaleReceipt,
  });

  FinixSaleReciptResponseRequest? finixSaleResponse;
  FinixSaleReceiptRequest? finixSaleReceipt;

  factory FinixResponseDto.fromJson(Map<String, dynamic> json) =>
      FinixResponseDto(
        finixSaleResponse:
            FinixSaleReciptResponseRequest.fromJson(json["finixSaleResponse"]),
        finixSaleReceipt:
            FinixSaleReceiptRequest.fromJson(json["finixSaleReceipt"]),
      );

  Map<String, dynamic> toJson() => {
        "finixSaleResponse": finixSaleResponse!.toJson(),
        "finixSaleReceipt": finixSaleReceipt!.toJson(),
      };
}

class FinixSaleReceiptRequest {
  FinixSaleReceiptRequest({
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

  factory FinixSaleReceiptRequest.fromJson(Map<String, dynamic> json) =>
      FinixSaleReceiptRequest(
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

class FinixSaleReciptResponseRequest {
  FinixSaleReciptResponseRequest({
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
  ResourceTagsRequest? resourceTags;
  String? entryMode;
  String? maskedAccountNumber;
  double? created;
  String? traceId;
  String? transferState;
  String? expirationYear;

  factory FinixSaleReciptResponseRequest.fromJson(Map<String, dynamic> json) =>
      FinixSaleReciptResponseRequest(
        transferId: json["transferId"],
        updated: json["updated"].toDouble(),
        amount: json["amount"],
        cardLogo: json["cardLogo"],
        cardHolderName: json["cardHolderName"],
        expirationMonth: json["expirationMonth"],
        resourceTags: ResourceTagsRequest.fromJson(json["resourceTags"]),
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

class ResourceTagsRequest {
  ResourceTagsRequest({
    this.customerEmail,
    this.customerName,
    this.eventName,
    this.eventCode,
    this.environment,
    this.paymentMethod,
  });

  String? customerEmail;
  String? customerName;
  String? eventName;
  String? eventCode;
  String? environment;
  String? paymentMethod;

  factory ResourceTagsRequest.fromJson(Map<String, dynamic> json) =>
      ResourceTagsRequest(
        customerEmail: json["customerEmail"],
        customerName: json["customerName"],
        eventName: json["eventName"],
        eventCode: json["eventCode"],
        environment: json["environment"],
        paymentMethod: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "customerEmail": customerEmail,
        "customerName": customerName,
        "eventName": eventName,
        "eventCode": eventCode,
        "environment": environment,
        "paymentMethod": paymentMethod,
      };
}
