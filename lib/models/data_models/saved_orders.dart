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
      required this.email,
      required this.phoneNumber,
      required this.phoneCountryCode,
      required this.address1,
      required this.address2,
      required this.country,
      required this.state,
      required this.city,
      required this.zipCode,
      required this.orderDate,
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
      email: map["email"],
      phoneNumber: map["phone_number"],
      phoneCountryCode: map["phone_country_code"],
      address1: map["address1"],
      address2: map["address2"],
      country: map["country"],
      state: map["state"],
      city: map["city"],
      zipCode: map["zip_code"],
      orderDate: map["order_date"],
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
    totalAmount:$totalAmount,
    payment:$payment,
    orderStatus:$orderStatus,
    deleted:$deleted
    """;
  }
}
