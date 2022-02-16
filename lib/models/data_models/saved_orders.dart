import 'package:kona_ice_pos/utils/date_formats.dart';

class SavedOrders {
  int id;
  String eventId;
  String cardId;
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
  num discount;
  num foodCost;
  num totalAmount;
  String payment;
  String orderStatus;
  bool deleted;

  SavedOrders(
      {this.id = 1,
      required this.eventId,
      required this.cardId,
      required this.orderId,
      required this.customerName,
       this.email= "NA",
       this.phoneNumber = "NA",
       this.phoneCountryCode="NA",
       this.address1="NA",
       this.address2="NA",
       this.country ="NA",
       this.state="NA",
       this.city="NA",
       this.zipCode="NA",
      required this.orderDate,
      required this.tip,
      required this.discount,
      required this.foodCost,
      required this.totalAmount,
      this.payment = 'NA',
      required this.orderStatus,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "eventId": eventId,
      "cardId": cardId,
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
      "tip":tip,
      "discount":discount,
      "foodCost":foodCost,
      "totalAmount": totalAmount,
      "payment": payment,
      "orderStatus": orderStatus,
      "deleted": deleted,
    };
  }

  factory SavedOrders.fromMap(Map<String, dynamic> map) {
    return SavedOrders(
      id: map["id"],
      eventId: map["event_id"],
      cardId: map["card_id"],
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
      discount: map["discount"],
      foodCost: map["food_cost"],
      totalAmount: map["total_amount"],
      payment: map["payment"],
      orderStatus: map["order_status"],
      deleted: map["deleted"] == 1,
    );
  }

  @override
  String toString() {
    return """
    id: $id,
    eventId:$eventId,
    cardId:$cardId,
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
    deleted:$deleted
    """;
  }

  String getOrderDateTime() {
    DateTime date = Date.getDateFromTimeStamp(timestamp: orderDate);
    String dateStr = Date.getDateFrom(date: date, formatValue: DateFormatsConstant.ddMMMYYY);
    String timeStr = Date.getDateFrom(date: date, formatValue: DateFormatsConstant.hhmmaa);

    return '$dateStr at $timeStr';
  }

  String getOrderDate() {
    DateTime date = Date.getDateFromTimeStamp(timestamp: orderDate);
    String dateStr = Date.getDateFrom(date: date, formatValue: DateFormatsConstant.ddMMMYYY);
    return dateStr;
  }
}
