

class FinixSendReceiptRequest {
  FinixSendReceiptRequest({
    this.email,
    this.phoneNumCountryCode,
    this.phoneNumber,
  });

  String? email;
  String? phoneNumCountryCode;
  String? phoneNumber;

  factory FinixSendReceiptRequest.fromJson(Map<String, dynamic> json) =>
      FinixSendReceiptRequest(
        email: json["email"],
        phoneNumCountryCode: json["phoneNumCountryCode"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNumCountryCode": phoneNumCountryCode,
        "phoneNumber": phoneNumber,
      };
}
