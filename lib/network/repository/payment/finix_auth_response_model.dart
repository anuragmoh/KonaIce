// To parse this JSON data, do
//
//     final finixAuthResponseModel = finixAuthResponseModelFromJson(jsonString);

import 'dart:convert';

FinixAuthResponseModel finixAuthResponseModelFromJson(String str) =>
    FinixAuthResponseModel.fromJson(json.decode(str));

String finixAuthResponseModelToJson(FinixAuthResponseModel data) =>
    json.encode(data.toJson());

class FinixAuthResponseModel {
  FinixAuthResponseModel({
    this.authorizationResponseModel,
    this.tipAmount,
    this.finixCaptureResponse,
  });

  AuthorizationResponseModel? authorizationResponseModel;
  dynamic tipAmount;
  AuthFinixCaptureResponse? finixCaptureResponse;

  factory FinixAuthResponseModel.fromJson(Map<String, dynamic> json) =>
      FinixAuthResponseModel(
        authorizationResponseModel: AuthorizationResponseModel.fromJson(
            json["authorizationResponseModel"]),
        tipAmount: json["tipAmount"],
        finixCaptureResponse:
            AuthFinixCaptureResponse.fromJson(json["finixCaptureResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "authorizationResponseModel": authorizationResponseModel!.toJson(),
        "tipAmount": tipAmount,
        "finixCaptureResponse": finixCaptureResponse!.toJson(),
      };
}

class AuthorizationResponseModel {
  AuthorizationResponseModel({
    this.finixAuthorizationResponse,
    this.finixAuthorizationReceipt,
  });

  FinixAuthorizationResponse? finixAuthorizationResponse;
  FinixAuthorizationReceipt? finixAuthorizationReceipt;

  factory AuthorizationResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthorizationResponseModel(
        finixAuthorizationResponse: FinixAuthorizationResponse.fromJson(
            json["finixAuthorizationResponse"]),
        finixAuthorizationReceipt: FinixAuthorizationReceipt.fromJson(
            json["finixAuthorizationReceipt"]),
      );

  Map<String, dynamic> toJson() => {
        "finixAuthorizationResponse": finixAuthorizationResponse!.toJson(),
        "finixAuthorizationReceipt": finixAuthorizationReceipt!.toJson(),
      };
}

class FinixAuthorizationReceipt {
  FinixAuthorizationReceipt({
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

  factory FinixAuthorizationReceipt.fromJson(Map<String, dynamic> json) =>
      FinixAuthorizationReceipt(
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

class FinixAuthorizationResponse {
  FinixAuthorizationResponse({
    this.transferId,
    this.updated,
    this.amount,
    this.cardLogo,
    this.cardHolderName,
    this.expirationMonth,
    this.resourceTags,
    this.emv,
    this.hostResponse,
    this.verification,
    this.entryMode,
    this.maskedAccountNumber,
    this.created,
    this.traceId,
    this.transferState,
    this.expirationYear,
  });

  String? transferId;
  double? updated;
  double? amount;
  String? cardLogo;
  String? cardHolderName;
  String? expirationMonth;
  FinixAuthorizationResponseResourceTags? resourceTags;
  String? emv;
  String? hostResponse;
  String? verification;
  String? entryMode;
  String? maskedAccountNumber;
  double? created;
  String? traceId;
  String? transferState;
  String? expirationYear;

  factory FinixAuthorizationResponse.fromJson(Map<String, dynamic> json) =>
      FinixAuthorizationResponse(
        transferId: json["transferId"],
        updated: json["updated"].toDouble(),
        amount: json["amount"].toDouble(),
        cardLogo: json["cardLogo"],
        cardHolderName: json["cardHolderName"],
        expirationMonth: json["expirationMonth"],
        resourceTags: FinixAuthorizationResponseResourceTags.fromJson(
            json["resourceTags"]),
        emv: json["emv"],
        hostResponse: json["hostResponse"],
        verification: json["verification"],
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
        "emv": emv,
        "hostResponse": hostResponse,
        "verification": verification,
        "entryMode": entryMode,
        "maskedAccountNumber": maskedAccountNumber,
        "created": created,
        "traceId": traceId,
        "transferState": transferState,
        "expirationYear": expirationYear,
      };
}

class FinixAuthorizationResponseResourceTags {
  FinixAuthorizationResponseResourceTags({
    this.environment,
    this.eventCode,
    this.paymentMethod,
    this.customerEmail,
    this.eventName,
    this.customerName,
  });

  String? environment;
  String? eventCode;
  String? paymentMethod;
  String? customerEmail;
  String? eventName;
  String? customerName;

  factory FinixAuthorizationResponseResourceTags.fromJson(
          Map<String, dynamic> json) =>
      FinixAuthorizationResponseResourceTags(
        environment: json["environment"],
        eventCode: json["eventCode"],
        paymentMethod: json["paymentMethod"],
        customerEmail: json["customerEmail"],
        eventName: json["eventName"],
        customerName: json["customerName"],
      );

  Map<String, dynamic> toJson() => {
        "environment": environment,
        "eventCode": eventCode,
        "paymentMethod": paymentMethod,
        "customerEmail": customerEmail,
        "eventName": eventName,
        "customerName": customerName,
      };
}

class AuthFinixCaptureResponse {
  AuthFinixCaptureResponse({
    this.amount,
    this.deviceId,
    this.updated,
    this.traceId,
    this.created,
    this.transferId,
    this.resourceTags,
    this.transferState,
  });

  double? amount;
  String? deviceId;
  double? updated;
  String? traceId;
  double? created;
  String? transferId;
  FinixCaptureResponseResourceTags? resourceTags;
  String? transferState;

  factory AuthFinixCaptureResponse.fromJson(Map<String, dynamic> json) =>
      AuthFinixCaptureResponse(
        amount: json["amount"].toDouble(),
        deviceId: json["deviceId"],
        updated: json["updated"].toDouble(),
        traceId: json["traceId"],
        created: json["created"].toDouble(),
        transferId: json["transferId"],
        resourceTags:
            FinixCaptureResponseResourceTags.fromJson(json["resourceTags"]),
        transferState: json["transferState"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "deviceId": deviceId,
        "updated": updated,
        "traceId": traceId,
        "created": created,
        "transferId": transferId,
        "resourceTags": resourceTags!.toJson(),
        "transferState": transferState,
      };
}

class FinixCaptureResponseResourceTags {
  FinixCaptureResponseResourceTags();

  factory FinixCaptureResponseResourceTags.fromJson(
          Map<String, dynamic> json) =>
      FinixCaptureResponseResourceTags();

  Map<String, dynamic> toJson() => {};
}
