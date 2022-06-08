import 'dart:convert';

PayOrderResponseModel payOrderResponseModelFromJson(String str) =>
    PayOrderResponseModel.fromJson(json.decode(str));

class PayOrderResponseModel {
  PayOrderResponseModel({
    this.status,
    this.messageKey,
  });

  String? status;
  String? messageKey;

  factory PayOrderResponseModel.fromJson(Map<String?, dynamic> json) =>
      PayOrderResponseModel(
        status: json["Status"],
        messageKey: json["messageKey"],
      );

  Map<String?, dynamic> toJson() => {
        "Status": status,
        "messageKey": messageKey,
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
  int? taxPercent;
  int? corporateDonation;
  String? orderId;
  dynamic donationAdminSharePercent;
  dynamic campaignId;
  String? eventId;
  int? donationAdminShareAmount;
  double? franchiseShare;
  int? adminSharePercent;
  double? grandTotal;
  double? franchiseShareBeforeFinalCal;
  int? donation;
  double? total;
  int? totalCampaignShare;
  int? taxAmount;
  int? convenienceFee;
  double? adminShare;
  int? deliveryFee;
  double? subTotal;
  double? foodTotal;
  int? givebackAmount;
  int? gratuity;
  String? billingZipCode;
  int? givebackPercent;
  String? billingState;
  int? campaignShare;
  int? franchiseDonation;
  double? adminShareBeforeFinalCal;
  String? billingAddressLine2;
  bool? ccChargesIncluded;
  int? ccChargesAmount;
  String? billingAddressLine1;
  String? billingCity;
  int? corporateDonationBeforeCcCharges;
  String? billingCountry;
  int? donationFranchiseSharePercent;
  double? creditCardFees;
  int? creditCardFeesPercent;

  factory OrderInvoice.fromJson(Map<String?, dynamic> json) => OrderInvoice(
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
        franchiseShareBeforeFinalCal:
            json["franchiseShareBeforeFinalCal"].toDouble(),
        donation: json["donation"],
        total: json["total"].toDouble(),
        totalCampaignShare: json["totalCampaignShare"],
        taxAmount: json["taxAmount"],
        convenienceFee: json["convenienceFee"],
        adminShare: json["adminShare"].toDouble(),
        deliveryFee: json["deliveryFee"],
        subTotal: json["subTotal"].toDouble(),
        foodTotal: json["foodTotal"].toDouble(),
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
        corporateDonationBeforeCcCharges:
            json["corporateDonationBeforeCcCharges"],
        billingCountry: json["billingCountry"],
        donationFranchiseSharePercent: json["donationFranchiseSharePercent"],
        creditCardFees: json["creditCardFees"].toDouble(),
        creditCardFeesPercent: json["creditCardFeesPercent"],
      );

  Map<String?, dynamic> toJson() => {
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

class OrderItemList {
  OrderItemList({
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
  List<dynamic>? foodExtraItemMappingList;
  double? unitPrice;
  String? key;
  String? values;
  String? recipientName;

  factory OrderItemList.fromJson(Map<String?, dynamic> json) => OrderItemList(
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
        totalAmount: json["totalAmount"].toDouble(),
        foodExtraItemMappingList:
            List<dynamic>.from(json["foodExtraItemMappingList"].map((x) => x)),
        unitPrice: json["unitPrice"].toDouble(),
        key: json["key"],
        values: json["values"],
        recipientName: json["recipientName"],
      );

  Map<String?, dynamic> toJson() => {
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
        "foodExtraItemMappingList":
            List<dynamic>.from((foodExtraItemMappingList ?? []).map((x) => x)),
        "unitPrice": unitPrice,
        "key": key,
        "values": values,
        "recipientName": recipientName,
      };
}
