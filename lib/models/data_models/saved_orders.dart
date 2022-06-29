import 'package:kona_ice_pos/utils/date_formats.dart';

class SavedOrders {
  String eventId;
  String cardId;
  String orderCode;
  String orderId;
  String customerName;
  String email;
  String phoneNumber;
  String phoneCountryCode;
  String address1;
  String address2;
  String country;
  String state;
  String city;
  String zipCode;
  int orderDate;
  num tip;
  num tax_amount;
  num discount;
  num foodCost;
  num totalAmount;
  num grandTotalAmount;
  String payment;
  String orderStatus;
  bool deleted;
  String paymentTerm;
  String refundAmount;
  String posPaymentMethod;

  SavedOrders(
      {required this.eventId,
      required this.cardId,
      required this.orderCode,
      required this.orderId,
      required this.customerName,
      this.email = "NA",
      this.phoneNumber = "NA",
      this.phoneCountryCode = "NA",
      this.address1 = "NA",
      this.address2 = "NA",
      this.country = "NA",
      this.state = "NA",
      this.city = "NA",
      this.zipCode = "NA",
      required this.orderDate,
      required this.tip,
      required this.tax_amount,
      required this.discount,
      required this.foodCost,
      required this.totalAmount,
      required this.grandTotalAmount,
      this.payment = 'NA',
      required this.orderStatus,
      required this.deleted,
      required this.paymentTerm,
      required this.refundAmount,
      this.posPaymentMethod = "NA"});

  Map<String, dynamic> toMap() {
    return {
      "eventId": eventId,
      "cardId": cardId,
      "orderCode": orderCode,
      "orderId": orderId,
      "customerName": customerName,
      "email": email,
      "phoneNumber": phoneNumber,
      "phoneCountryCode": phoneCountryCode,
      "address1": address1,
      "address2": address2,
      "country": country,
      "state": state,
      "city": city,
      "zipCode": zipCode,
      "orderDate": orderDate,
      "tip": tip,
      "tax_amount": tax_amount,
      "discount": discount,
      "foodCost": foodCost,
      "totalAmount": totalAmount,
      "grandTotal": grandTotalAmount,
      "payment": payment,
      "orderStatus": orderStatus,
      "deleted": deleted,
      "paymentTerm": paymentTerm,
      "refundAmount": refundAmount,
      "posPaymentMethod": posPaymentMethod
    };
  }

  factory SavedOrders.fromMap(Map<String, dynamic> map) {
    return SavedOrders(
        eventId: map["event_id"],
        cardId: map["card_id"],
        orderCode: map["order_code"],
        orderId: map["order_id"],
        customerName: map["customer_name"],
        email: map["email"].toString(),
        phoneNumber: map["phone_number"].toString(),
        phoneCountryCode: map["phone_country_code"].toString(),
        address1: map["address1"].toString(),
        address2: map["address2"].toString(),
        country: map["country"].toString(),
        state: map["state"].toString(),
        city: map["city"].toString(),
        zipCode: map["zip_code"].toString(),
        orderDate: map["order_date"],
        tip: map["tip"],
        tax_amount: map["tax_amount"],
        discount: map["discount"],
        foodCost: map["food_cost"],
        totalAmount: map["total_amount"],
        grandTotalAmount: map["grand_total"],
        payment: map["payment"],
        orderStatus: map["order_status"],
        deleted: map["deleted"] == 1,
        paymentTerm: map["payment_term"],
        refundAmount: map["refund_amount"],
        posPaymentMethod: map["pos_payment_method"]);
  }

  @override
  String toString() {
    return """
    eventId:$eventId,
    cardId:$cardId,
    orderCode:$orderCode,
    orderId:$orderId,
    customerName:$customerName,
    email:$email,
    phoneNumber:$phoneNumber,
    phoneCountryCode:$phoneCountryCode,
    address1:$address1,
    address2:$address2,
    country:$country,
    state:$state,
    city:$city,
    zipCode:$zipCode,
    orderDate:$orderDate,
    tip:$tip,
    discount:$discount,
    foodCost:$foodCost,
    totalAmount:$totalAmount,
    payment:$payment,
    orderStatus:$orderStatus,
    deleted:$deleted,
    paymentTerm:$paymentTerm,
    refundAmount:$refundAmount,
    posPaymentMethod:$posPaymentMethod
    """;
  }

  String getOrderDateTime() {
    DateTime date = Date.getDateFromTimeStamp(timestamp: orderDate);
/*    String dateStr =
        Date.getDateFrom(date: date, formatValue: DateFormatsConstant.ddMMMYYY);*/
    String timeStr =
        Date.getDateFrom(date: date, formatValue: DateFormatsConstant.hhmmaa);

    return timeStr;
  }

  String getOrderDate() {
    DateTime date = Date.getDateFromTimeStamp(timestamp: orderDate);
    String dateStr =
        Date.getDateFrom(date: date, formatValue: DateFormatsConstant.ddMMMYYY);
    return dateStr;
  }
}
