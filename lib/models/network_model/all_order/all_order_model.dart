import 'dart:convert';

AllOrderResponse allOrderResponseFromJson(String str) => AllOrderResponse.fromJson(json.decode(str));

String allOrderResponseToJson(AllOrderResponse data) => json.encode(data.toJson());

class AllOrderResponse {
  AllOrderResponse({
    this.count,
    this.limit,
    this.offset,
    this.sortColumn,
    this.sortType,
    this.searchText,
    this.data,
    this.fromDate,
    this.toDate,
  });

  int? count;
  int? limit;
  int? offset;
  dynamic sortColumn;
  dynamic sortType;
  String? searchText;
  List<Datum>? data;
  int? fromDate;
  int? toDate;

  factory AllOrderResponse.fromJson(Map<String, dynamic> json) => AllOrderResponse(
    count: json["count"],
    limit: json["limit"],
    offset: json["offset"],
    sortColumn: json["sortColumn"],
    sortType: json["sortType"],
    searchText: json["searchText"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    fromDate: json["fromDate"],
    toDate: json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "limit": limit,
    "offset": offset,
    "sortColumn": sortColumn,
    "sortType": sortType,
    "searchText": searchText,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "fromDate": fromDate,
    "toDate": toDate,
  };
}

class Datum {
  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.eventId,
    this.franchiseId,
    this.orderCode,
    this.anonymousId,
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
    this.key,
    this.values,
    this.specialInstructions,
    this.orderStatus,
    this.paymentStatus,
    this.countryName,
    this.stateName,
    this.refundAmount,
    this.recipientName,
    this.campaignShareRefund,
    this.orderAmountRefund,
    this.totalRefund,
    this.addressLocation,
    this.addressLatitude,
    this.addressLongitude,
    this.paymentTerm,
    this.slotInterval1,
    this.slotInterval2,
    this.orderDate,
    this.preOrder,
    this.orderAttribute,
    this.partialRefund,
    this.adminRefundAmount,
    this.franchiseRefundAmount,
    this.userId,
    this.paymentModule,
    this.createdByRoleCode,
    this.subAccountId,
    this.userAddressId,
    this.orderItemsList,
    this.franchisePhoneNumber,
    this.orderInvoice,
    this.franchiseAddressLine2,
    this.stripePublishableKey,
    this.franchiseState,
    this.connectedStripeAccountId,
    this.franchiseAddressLine1,
    this.clientSecret,
    this.franchiseName,
    this.franchiseCode,
    this.franchiseEmail,
    this.franchisePhoneNumCountryCode,
    this.franchiseCountry,
    this.franchiseCity,
    this.franchiseZipCode,
    this.eventStateName,
    this.eventName,
    this.eventAddressLine2,
    this.eventCode,
    this.startDateTime,
    this.endDateTime,
    this.eventAddressLine1,
    this.eventCountryName,
    this.eventCity,
    this.eventZipCode,
    this.gratuityFieldLabel,
    this.additionalPaymentFieldLabel,
    this.minimumOrderAmount,
    this.displayAdditionalPaymentField,
    this.campaign,
    this.displayGratuityField,
    this.comments,
    this.transactionId,
    this.locationNotes,
    this.minimumDeliveryTime,
    this.deliveryMessage,
    this.useTimeSlot,
    this.recipientNameLabel,
    this.smsNotification,
    this.emailNotification,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? eventId;
  String? franchiseId;
  String? orderCode;
  dynamic anonymousId;
  dynamic campaignId;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic phoneNumCountryCode;
  dynamic phoneNumber;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zipCode;
  dynamic key;
  dynamic values;
  dynamic specialInstructions;
  String? orderStatus;
  String? paymentStatus;
  dynamic countryName;
  dynamic stateName;
  dynamic refundAmount;
  dynamic recipientName;
  bool? campaignShareRefund;
  bool? orderAmountRefund;
  bool? totalRefund;
  dynamic addressLocation;
  double? addressLatitude;
  double? addressLongitude;
  String? paymentTerm;
  int? slotInterval1;
  int? slotInterval2;
  int? orderDate;
  bool? preOrder;
  String? orderAttribute;
  bool? partialRefund;
  dynamic adminRefundAmount;
  dynamic franchiseRefundAmount;
  String? userId;
  String? paymentModule;
  String? createdByRoleCode;
  dynamic subAccountId;
  dynamic userAddressId;
  List<OrderItemsList>? orderItemsList;
  String? franchisePhoneNumber;
  OrderInvoice? orderInvoice;
  dynamic franchiseAddressLine2;
  dynamic stripePublishableKey;
  dynamic franchiseState;
  dynamic connectedStripeAccountId;
  String? franchiseAddressLine1;
  dynamic clientSecret;
  String? franchiseName;
  String? franchiseCode;
  String? franchiseEmail;
  String? franchisePhoneNumCountryCode;
  String? franchiseCountry;
  String? franchiseCity;
  String? franchiseZipCode;
  String? eventStateName;
  String? eventName;
  String? eventAddressLine2;
  String? eventCode;
  int? startDateTime;
  int? endDateTime;
  String? eventAddressLine1;
  String? eventCountryName;
  String? eventCity;
  String? eventZipCode;
  String? gratuityFieldLabel;
  String? additionalPaymentFieldLabel;
  double? minimumOrderAmount;
  bool? displayAdditionalPaymentField;
  dynamic campaign;
  bool? displayGratuityField;
  dynamic comments;
  dynamic transactionId;
  String? locationNotes;
  int? minimumDeliveryTime;
  String? deliveryMessage;
  bool? useTimeSlot;
  String? recipientNameLabel;
  bool? smsNotification;
  bool? emailNotification;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
    eventId: json["eventId"],
    franchiseId: json["franchiseId"],
    orderCode: json["orderCode"],
    anonymousId: json["anonymousId"],
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
    key: json["key"],
    values: json["values"],
    specialInstructions: json["specialInstructions"],
    orderStatus: json["orderStatus"],
    paymentStatus: json["paymentStatus"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    refundAmount: json["refundAmount"],
    recipientName: json["recipientName"],
    campaignShareRefund: json["campaignShareRefund"],
    orderAmountRefund: json["orderAmountRefund"],
    totalRefund: json["totalRefund"],
    addressLocation: json["addressLocation"],
    addressLatitude: json["addressLatitude"],
    addressLongitude: json["addressLongitude"],
    paymentTerm: json["paymentTerm"],
    slotInterval1: json["slotInterval1"],
    slotInterval2: json["slotInterval2"],
    orderDate: json["orderDate"],
    preOrder: json["preOrder"],
    orderAttribute: json["orderAttribute"],
    partialRefund: json["partialRefund"],
    adminRefundAmount: json["adminRefundAmount"],
    franchiseRefundAmount: json["franchiseRefundAmount"],
    userId: json["userId"],
    paymentModule: json["paymentModule"],
    createdByRoleCode: json["createdByRoleCode"],
    subAccountId: json["subAccountId"],
    userAddressId: json["userAddressId"],
    orderItemsList: List<OrderItemsList>.from(json["orderItemsList"].map((x) => OrderItemsList.fromJson(x))),
    franchisePhoneNumber: json["franchisePhoneNumber"],
    orderInvoice: OrderInvoice.fromJson(json["orderInvoice"]),
    franchiseAddressLine2: json["franchiseAddressLine2"],
    stripePublishableKey: json["stripePublishableKey"],
    franchiseState: json["franchiseState"],
    connectedStripeAccountId: json["connectedStripeAccountId"],
    franchiseAddressLine1: json["franchiseAddressLine1"],
    clientSecret: json["clientSecret"],
    franchiseName: json["franchiseName"],
    franchiseCode: json["franchiseCode"],
    franchiseEmail: json["franchiseEmail"],
    franchisePhoneNumCountryCode: json["franchisePhoneNumCountryCode"],
    franchiseCountry: json["franchiseCountry"],
    franchiseCity: json["franchiseCity"],
    franchiseZipCode: json["franchiseZipCode"],
    eventStateName: json["eventStateName"],
    eventName: json["eventName"],
    eventAddressLine2: json["eventAddressLine2"],
    eventCode: json["eventCode"],
    startDateTime: json["startDateTime"],
    endDateTime: json["endDateTime"],
    eventAddressLine1: json["eventAddressLine1"],
    eventCountryName: json["eventCountryName"],
    eventCity: json["eventCity"],
    eventZipCode: json["eventZipCode"],
    gratuityFieldLabel: json["gratuityFieldLabel"],
    additionalPaymentFieldLabel: json["additionalPaymentFieldLabel"],
    minimumOrderAmount: json["minimumOrderAmount"],
    displayAdditionalPaymentField: json["displayAdditionalPaymentField"],
    campaign: json["campaign"],
    displayGratuityField: json["displayGratuityField"],
    comments: json["comments"],
    transactionId: json["transactionId"],
    locationNotes: json["locationNotes"],
    minimumDeliveryTime: json["minimumDeliveryTime"],
    deliveryMessage: json["deliveryMessage"],
    useTimeSlot: json["useTimeSlot"],
    recipientNameLabel: json["recipientNameLabel"],
    smsNotification: json["smsNotification"],
    emailNotification: json["emailNotification"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
    "eventId": eventId,
    "franchiseId": franchiseId,
    "orderCode": orderCode,
    "anonymousId": anonymousId,
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
    "key": key,
    "values": values,
    "specialInstructions": specialInstructions,
    "orderStatus": orderStatus,
    "paymentStatus": paymentStatus,
    "countryName": countryName,
    "stateName": stateName,
    "refundAmount": refundAmount,
    "recipientName": recipientName,
    "campaignShareRefund": campaignShareRefund,
    "orderAmountRefund": orderAmountRefund,
    "totalRefund": totalRefund,
    "addressLocation": addressLocation,
    "addressLatitude": addressLatitude,
    "addressLongitude": addressLongitude,
    "paymentTerm": paymentTerm,
    "slotInterval1": slotInterval1,
    "slotInterval2": slotInterval2,
    "orderDate": orderDate,
    "preOrder": preOrder,
    "orderAttribute": orderAttribute,
    "partialRefund": partialRefund,
    "adminRefundAmount": adminRefundAmount,
    "franchiseRefundAmount": franchiseRefundAmount,
    "userId": userId,
    "paymentModule": paymentModule,
    "createdByRoleCode": createdByRoleCode,
    "subAccountId": subAccountId,
    "userAddressId": userAddressId,
    "orderItemsList": List<dynamic>.from(orderItemsList!.map((x) => x.toJson())),
    "franchisePhoneNumber": franchisePhoneNumber,
    "orderInvoice": orderInvoice!.toJson(),
    "franchiseAddressLine2": franchiseAddressLine2,
    "stripePublishableKey": stripePublishableKey,
    "franchiseState": franchiseState,
    "connectedStripeAccountId": connectedStripeAccountId,
    "franchiseAddressLine1": franchiseAddressLine1,
    "clientSecret": clientSecret,
    "franchiseName": franchiseName,
    "franchiseCode": franchiseCode,
    "franchiseEmail": franchiseEmail,
    "franchisePhoneNumCountryCode": franchisePhoneNumCountryCode,
    "franchiseCountry": franchiseCountry,
    "franchiseCity": franchiseCity,
    "franchiseZipCode": franchiseZipCode,
    "eventStateName": eventStateName,
    "eventName": eventName,
    "eventAddressLine2": eventAddressLine2,
    "eventCode": eventCode,
    "startDateTime": startDateTime,
    "endDateTime": endDateTime,
    "eventAddressLine1": eventAddressLine1,
    "eventCountryName": eventCountryName,
    "eventCity": eventCity,
    "eventZipCode": eventZipCode,
    "gratuityFieldLabel": gratuityFieldLabel,
    "additionalPaymentFieldLabel": additionalPaymentFieldLabel,
    "minimumOrderAmount": minimumOrderAmount,
    "displayAdditionalPaymentField": displayAdditionalPaymentField,
    "campaign": campaign,
    "displayGratuityField": displayGratuityField,
    "comments": comments,
    "transactionId": transactionId,
    "locationNotes": locationNotes,
    "minimumDeliveryTime": minimumDeliveryTime,
    "deliveryMessage": deliveryMessage,
    "useTimeSlot": useTimeSlot,
    "recipientNameLabel": recipientNameLabel,
    "smsNotification": smsNotification,
    "emailNotification": emailNotification,
  };
}

class OrderInvoice {
  OrderInvoice({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.taxPercent,
    this.corporateDonation,
    this.orderId,
    this.donationAdminSharePercent,
    this.campaignId,
    this.eventId,
    this.donationAdminShareAmount,
    this.franchiseShare,
    this.adminSharePercent,
    this.grandTotal,
    this.franchiseShareBeforeFinalCal,
    this.donation,
    this.total,
    this.totalCampaignShare,
    this.taxAmount,
    this.convenienceFee,
    this.adminShare,
    this.deliveryFee,
    this.subTotal,
    this.foodTotal,
    this.givebackAmount,
    this.gratuity,
    this.billingZipCode,
    this.givebackPercent,
    this.billingState,
    this.campaignShare,
    this.franchiseDonation,
    this.adminShareBeforeFinalCal,
    this.billingAddressLine2,
    this.ccChargesIncluded,
    this.ccChargesAmount,
    this.billingAddressLine1,
    this.billingCity,
    this.corporateDonationBeforeCcCharges,
    this.billingCountry,
    this.donationFranchiseSharePercent,
    this.creditCardFees,
    this.creditCardFeesPercent,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  double? taxPercent;
  double? corporateDonation;
  String? orderId;
  dynamic donationAdminSharePercent;
  dynamic campaignId;
  String? eventId;
  double? donationAdminShareAmount;
  double? franchiseShare;
  double? adminSharePercent;
  double? grandTotal;
  double? franchiseShareBeforeFinalCal;
  double? donation;
  double? total;
  double? totalCampaignShare;
  double? taxAmount;
  double? convenienceFee;
  double? adminShare;
  double? deliveryFee;
  double? subTotal;
  double? foodTotal;
  double? givebackAmount;
  double? gratuity;
  dynamic billingZipCode;
  double? givebackPercent;
  dynamic billingState;
  double? campaignShare;
  double? franchiseDonation;
  double? adminShareBeforeFinalCal;
  dynamic billingAddressLine2;
  bool? ccChargesIncluded;
  double? ccChargesAmount;
  dynamic billingAddressLine1;
  dynamic billingCity;
  double? corporateDonationBeforeCcCharges;
  dynamic billingCountry;
  double? donationFranchiseSharePercent;
  double? creditCardFees;
  double? creditCardFeesPercent;

  factory OrderInvoice.fromJson(Map<String, dynamic> json) => OrderInvoice(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
    taxPercent: json["taxPercent"],
    corporateDonation: json["corporateDonation"],
    orderId: json["orderId"],
    donationAdminSharePercent: json["donationAdminSharePercent"],
    campaignId: json["campaignId"],
    eventId: json["eventId"],
    donationAdminShareAmount: json["donationAdminShareAmount"],
    franchiseShare: json["franchiseShare"].toDouble(),
    adminSharePercent: json["adminSharePercent"],
    grandTotal: json["grandTotal"].toDouble(),
    franchiseShareBeforeFinalCal: json["franchiseShareBeforeFinalCal"].toDouble(),
    donation: json["donation"],
    total: json["total"],
    totalCampaignShare: json["totalCampaignShare"],
    taxAmount: json["taxAmount"],
    convenienceFee: json["convenienceFee"],
    adminShare: json["adminShare"].toDouble(),
    deliveryFee: json["deliveryFee"],
    subTotal: json["subTotal"],
    foodTotal: json["foodTotal"],
    givebackAmount: json["givebackAmount"],
    gratuity: json["gratuity"],
    billingZipCode: json["billingZipCode"],
    givebackPercent: json["givebackPercent"],
    billingState: json["billingState"],
    campaignShare: json["campaignShare"],
    franchiseDonation: json["franchiseDonation"],
    adminShareBeforeFinalCal: json["adminShareBeforeFinalCal"].toDouble(),
    billingAddressLine2: json["billingAddressLine2"],
    ccChargesIncluded: json["ccChargesIncluded"],
    ccChargesAmount: json["ccChargesAmount"],
    billingAddressLine1: json["billingAddressLine1"],
    billingCity: json["billingCity"],
    corporateDonationBeforeCcCharges: json["corporateDonationBeforeCcCharges"],
    billingCountry: json["billingCountry"],
    donationFranchiseSharePercent: json["donationFranchiseSharePercent"],
    creditCardFees: json["creditCardFees"].toDouble(),
    creditCardFeesPercent: json["creditCardFeesPercent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
    "taxPercent": taxPercent,
    "corporateDonation": corporateDonation,
    "orderId": orderId,
    "donationAdminSharePercent": donationAdminSharePercent,
    "campaignId": campaignId,
    "eventId": eventId,
    "donationAdminShareAmount": donationAdminShareAmount,
    "franchiseShare": franchiseShare,
    "adminSharePercent": adminSharePercent,
    "grandTotal": grandTotal,
    "franchiseShareBeforeFinalCal": franchiseShareBeforeFinalCal,
    "donation": donation,
    "total": total,
    "totalCampaignShare": totalCampaignShare,
    "taxAmount": taxAmount,
    "convenienceFee": convenienceFee,
    "adminShare": adminShare,
    "deliveryFee": deliveryFee,
    "subTotal": subTotal,
    "foodTotal": foodTotal,
    "givebackAmount": givebackAmount,
    "gratuity": gratuity,
    "billingZipCode": billingZipCode,
    "givebackPercent": givebackPercent,
    "billingState": billingState,
    "campaignShare": campaignShare,
    "franchiseDonation": franchiseDonation,
    "adminShareBeforeFinalCal": adminShareBeforeFinalCal,
    "billingAddressLine2": billingAddressLine2,
    "ccChargesIncluded": ccChargesIncluded,
    "ccChargesAmount": ccChargesAmount,
    "billingAddressLine1": billingAddressLine1,
    "billingCity": billingCity,
    "corporateDonationBeforeCcCharges": corporateDonationBeforeCcCharges,
    "billingCountry": billingCountry,
    "donationFranchiseSharePercent": donationFranchiseSharePercent,
    "creditCardFees": creditCardFees,
    "creditCardFeesPercent": creditCardFeesPercent,
  };
}

class OrderItemsList {
  OrderItemsList({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.orderId,
    this.quantity,
    this.itemId,
    this.itemCategoryId,
    this.name,
    this.totalAmount,
    this.foodExtraItemMappingList,
    this.unitPrice,
    this.key,
    this.values,
    this.recipientName,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? orderId;
  int? quantity;
  String? itemId;
  String? itemCategoryId;
  String? name;
  double? totalAmount;
  List<FoodExtraItemMappingList>? foodExtraItemMappingList;
  double? unitPrice;
  String? key;
  String? values;
  String? recipientName;

  factory OrderItemsList.fromJson(Map<String, dynamic> json) => OrderItemsList(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
    orderId: json["orderId"],
    quantity: json["quantity"],
    itemId: json["itemId"],
    itemCategoryId: json["itemCategoryId"],
    name: json["name"],
    totalAmount: json["totalAmount"],
    foodExtraItemMappingList: List<FoodExtraItemMappingList>.from(json["foodExtraItemMappingList"].map((x) => FoodExtraItemMappingList.fromJson(x))),
    unitPrice: json["unitPrice"],
    key: json["key"],
    values: json["values"],
    recipientName: json["recipientName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
    "orderId": orderId,
    "quantity": quantity,
    "itemId": itemId,
    "itemCategoryId": itemCategoryId,
    "name": name,
    "totalAmount": totalAmount,
    "foodExtraItemMappingList": List<dynamic>.from(foodExtraItemMappingList!.map((x) => x.toJson())),
    "unitPrice": unitPrice,
    "key": key,
    "values": values,
    "recipientName": recipientName,
  };
}

class FoodExtraItemMappingList {
  FoodExtraItemMappingList({
    this.foodExtraCategoryId,
    this.foodExtraCategoryName,
    this.orderFoodExtraItemDetailDto,
  });

  String? foodExtraCategoryId;
  dynamic foodExtraCategoryName;
  List<OrderFoodExtraItemDetailDto>? orderFoodExtraItemDetailDto;

  factory FoodExtraItemMappingList.fromJson(Map<String, dynamic> json) => FoodExtraItemMappingList(
    foodExtraCategoryId: json["foodExtraCategoryId"],
    foodExtraCategoryName: json["foodExtraCategoryName"],
    orderFoodExtraItemDetailDto: List<OrderFoodExtraItemDetailDto>.from(json["orderFoodExtraItemDetailDto"].map((x) => OrderFoodExtraItemDetailDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foodExtraCategoryId": foodExtraCategoryId,
    "foodExtraCategoryName": foodExtraCategoryName,
    "orderFoodExtraItemDetailDto": List<dynamic>.from(orderFoodExtraItemDetailDto!.map((x) => x.toJson())),
  };
}

class OrderFoodExtraItemDetailDto {
  OrderFoodExtraItemDetailDto({
    this.id,
    this.foodExtraItemName,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
    this.specialInstructions,
  });

  String? id;
  String? foodExtraItemName;
  int? quantity;
  double? unitPrice;
  double? totalAmount;
  dynamic specialInstructions;

  factory OrderFoodExtraItemDetailDto.fromJson(Map<String, dynamic> json) => OrderFoodExtraItemDetailDto(
    id: json["id"],
    foodExtraItemName: json["foodExtraItemName"],
    quantity: json["quantity"],
    unitPrice: json["unitPrice"],
    totalAmount: json["totalAmount"],
    specialInstructions: json["specialInstructions"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "foodExtraItemName": foodExtraItemName,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "totalAmount": totalAmount,
    "specialInstructions": specialInstructions,
  };
}
