import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';

class PlaceOrderRequestModel {
  PlaceOrderRequestModel({
    this.id,
    this.eventId,
    this.cardId,
    this.campaignId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumCountryCode,
    this.phoneNumber,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.anonymous,
    this.donation,
    this.gratuity,
    this.ccChargesIncluded,
    this.corporateDonation,
    this.corporateDonationBeforeCcCharges,
    this.ccChargesAmount,
    this.addressLatitude,
    this.addressLongitude,
    this.slotInterval1,
    this.slotInterval2,
    this.orderDate,
    this.allowPromoNotifications,
    this.orderItemsList,
  });

  String? id;
  String? eventId;
  String? cardId;
  String? campaignId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumCountryCode;
  String? phoneNumber;
  String? addressLine1;
  String? addressLine2;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  bool? anonymous;
  int? donation;
  int? gratuity;
  int? ccChargesIncluded;
  int? corporateDonation;
  num? corporateDonationBeforeCcCharges;
  int? ccChargesAmount;
  double? addressLatitude;
  double? addressLongitude;
  int? slotInterval1;
  int? slotInterval2;
  int? orderDate;
  bool? allowPromoNotifications;
  List<OrderItemsList>? orderItemsList;

  factory PlaceOrderRequestModel.fromJson(Map<String?, dynamic> json) =>
      PlaceOrderRequestModel(
        id: json["id"],
        eventId: json["eventId"],
        cardId: json["cardId"],
        campaignId: json["campaignId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumCountryCode: json["phoneNumCountryCode"],
        phoneNumber: json["phoneNumber"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        zipCode: json["zipCode"],
        anonymous: json["anonymous"],
        donation: json["donation"],
        gratuity: json["gratuity"],
        ccChargesIncluded: json["ccChargesIncluded"],
        corporateDonation: json["corporateDonation"],
        corporateDonationBeforeCcCharges:
            json["corporateDonationBeforeCcCharges"],
        ccChargesAmount: json["ccChargesAmount"],
        addressLatitude: json["addressLatitude"].toDouble(),
        addressLongitude: json["addressLongitude"].toDouble(),
        slotInterval1: json["slotInterval1"],
        slotInterval2: json["slotInterval2"],
        orderDate: json["orderDate"],
        allowPromoNotifications: json["allowPromoNotifications"],
        orderItemsList: List<OrderItemsList>.from(
            json["orderItemsList"].map((x) => OrderItemsList.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "cardId": cardId,
        "campaignId": campaignId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumCountryCode": phoneNumCountryCode,
        "phoneNumber": phoneNumber,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "country": country,
        "state": state,
        "city": city,
        "zipCode": zipCode,
        "anonymous": anonymous,
        "donation": donation,
        "gratuity": gratuity,
        "ccChargesIncluded": ccChargesIncluded,
        "corporateDonation": corporateDonation,
        "corporateDonationBeforeCcCharges": corporateDonationBeforeCcCharges,
        "ccChargesAmount": ccChargesAmount,
        "addressLatitude": addressLatitude,
        "addressLongitude": addressLongitude,
        "slotInterval1": slotInterval1,
        "slotInterval2": slotInterval2,
        "orderDate": orderDate,
        "allowPromoNotifications": allowPromoNotifications,
        "orderItemsList":
            List<dynamic>.from((orderItemsList ?? []).map((x) => x.toJson())),
      };

  String getCustomerName() {
    return (anonymous ?? true)
        ? StringConstants.guestCustomer
        : '$firstName $lastName'.toTitleCase();
  }

  String getOrderDate() {
    DateTime date = Date.getDateFromTimeStamp(
        timestamp: orderDate ?? DateTime.now().millisecondsSinceEpoch);
    String dateStr =
        Date.getDateFrom(date: date, formatValue: DateFormatsConstant.ddMMMYYY);
    String timeStr =
        Date.getDateFrom(date: date, formatValue: DateFormatsConstant.hhmmaa);

    return '$dateStr at $timeStr';
  }

  String getPhoneNumber() {
    String phoneNum = phoneNumber ?? '';
    String countryCode = phoneNumCountryCode ?? '';
    if (phoneNum == '' && countryCode == '') {
      return '';
    } else {
      return '$countryCode $phoneNum';
    }
  }
}

class OrderItemsList {
  OrderItemsList({
    this.itemId,
    this.name,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
    this.itemCategoryId,
    this.key,
    this.values,
    this.recipientName,
    this.foodExtraItemMappingList,
  });

  String? itemId;
  String? name;
  int? quantity;
  double? unitPrice;
  double? totalAmount;
  String? itemCategoryId;
  String? key;
  String? values;
  String? recipientName;
  List<FoodExtraItemMappingList>? foodExtraItemMappingList;

  factory OrderItemsList.fromJson(Map<String?, dynamic> json) => OrderItemsList(
        itemId: json["itemId"],
        name: json["name"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        totalAmount: json["totalAmount"],
        itemCategoryId: json["itemCategoryId"],
        key: json["key"],
        values: json["values"],
        recipientName: json["recipientName"],
        foodExtraItemMappingList: List<FoodExtraItemMappingList>.from(
            json["foodExtraItemMappingList"]
                .map((x) => FoodExtraItemMappingList.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "itemId": itemId,
        "name": name,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "totalAmount": totalAmount,
        "itemCategoryId": itemCategoryId,
        "key": key,
        "values": values,
        "recipientName": recipientName,
        "foodExtraItemMappingList": List<dynamic>.from(
            (foodExtraItemMappingList ?? []).map((x) => x.toJson())),
      };

  double getTotalPrice() {
    double totalExtraItemPrice = 0;
    if ((foodExtraItemMappingList ?? []).isNotEmpty &&
        (foodExtraItemMappingList![0].orderFoodExtraItemDetailDto ?? [])
            .isNotEmpty) {
      for (var element
          in foodExtraItemMappingList![0].orderFoodExtraItemDetailDto!) {
        totalExtraItemPrice += element.totalAmount ?? 0;
      }
    }
    return (totalAmount ?? 0) + totalExtraItemPrice;
  }
}

class FoodExtraItemMappingList {
  FoodExtraItemMappingList({
    this.foodExtraCategoryId,
    this.orderFoodExtraItemDetailDto,
  });

  String? foodExtraCategoryId;
  List<OrderFoodExtraItemDetailDto>? orderFoodExtraItemDetailDto;

  factory FoodExtraItemMappingList.fromJson(Map<String?, dynamic> json) =>
      FoodExtraItemMappingList(
        foodExtraCategoryId: json["foodExtraCategoryId"],
        orderFoodExtraItemDetailDto: List<OrderFoodExtraItemDetailDto>.from(
            json["orderFoodExtraItemDetailDto"]
                .map((x) => OrderFoodExtraItemDetailDto.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "foodExtraCategoryId": foodExtraCategoryId,
        "orderFoodExtraItemDetailDto": List<dynamic>.from(
            (orderFoodExtraItemDetailDto ?? []).map((x) => x.toJson())),
      };
}

class OrderFoodExtraItemDetailDto {
  OrderFoodExtraItemDetailDto({
    this.id,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
    this.specialInstructions,
    this.name,
  });

  String? id;
  int? quantity;
  double? unitPrice;
  double? totalAmount;
  String? specialInstructions;
  String? name;

  factory OrderFoodExtraItemDetailDto.fromJson(Map<String?, dynamic> json) =>
      OrderFoodExtraItemDetailDto(
        id: json["id"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        totalAmount: json["totalAmount"],
        specialInstructions: json["specialInstructions"],
        name: json["foodExtraItemName"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "totalAmount": totalAmount,
        "specialInstructions": specialInstructions,
        "foodExtraItemName": name,
      };
}
