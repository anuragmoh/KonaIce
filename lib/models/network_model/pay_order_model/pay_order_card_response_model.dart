import 'dart:convert';

PayOrderResponseCardModel payOrderResponseCardModelFromJson(String str) =>
    PayOrderResponseCardModel.fromJson(json.decode(str));

class PayOrderResponseCardModel {
  PayOrderResponseCardModel({
    required this.status,
    required this.messageKey,
    required this.orderItemsInvoiceDto,
  });

  String status;
  String messageKey;
  OrderItemsInvoiceDto orderItemsInvoiceDto;

  factory PayOrderResponseCardModel.fromJson(Map<String, dynamic> json) =>
      PayOrderResponseCardModel(
        status: json["Status"],
        messageKey: json["messageKey"],
        orderItemsInvoiceDto:
            OrderItemsInvoiceDto.fromJson(json["orderItemsInvoiceDto"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "messageKey": messageKey,
        "orderItemsInvoiceDto": orderItemsInvoiceDto.toJson(),
      };
}

class OrderItemsInvoiceDto {
  OrderItemsInvoiceDto({
    this.transactionId,
  });

  dynamic transactionId;

  factory OrderItemsInvoiceDto.fromJson(Map<String, dynamic> json) =>
      OrderItemsInvoiceDto(
        transactionId: json["transactionId"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
      };
}
