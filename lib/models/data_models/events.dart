class Events {
  final String id;
  final String eventCode;
  final String name;
  final int startDateTime;
  final int endDateTime;
  final String delivery;
  final String link;
  final String addressLine1;
  final String addressLine2;
  final String country;
  final String state;
  final String city;
  final String zipCode;
  final String contactName;
  final String contactEmail;
  final String contactPhoneNumCountryCode;
  final String contactPhoneNumber;
  final String key;
  final String values;
  final bool displayAdditionalPaymentField;
  final String additionalPaymentFieldLabel;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final String franchiseId;
  final num minimumOrderAmount;
  final String eventStatus;
  final String specialInstructionLabel;
  final bool displayGratuityField;
  final String gratuityFieldLabel;
  final String campaignId;
  final bool enableDonation;
  final String donationFieldLabel;
  final String assetId;
  final String weatherType;
  final String paymentTerm;
  final String secondaryContactName;
  final String secondaryContactEmail;
  final String secondaryContactPhoneNumCountryCode;
  final String secondaryContactPhoneNumber;
  final String notes;
  final String eventType;
  final bool preOrder;
  final int radius;
  final int timeSlot;
  final int maxOrderInSlot;
  final String locationNotes;
  final String orderAttribute;
  final int minimumDeliveryTime;
  final String startAddress;
  final bool useTimeSlot;
  final int maxAllowedOrders;
  final String deliveryMessage;
  final String recipientNameLabel;
  final int orderStartDateTime;
  final int orderEndDateTime;
  final bool smsNotification;
  final bool emailNotification;
  final String clientId;
  final String recurringType;
  final String days;
  final int monthlyDateTime;
  final int expiryDate;
  final bool lastDayOfMonth;
  final String seriesId;
  final String manualStatus;
  final num entryFee;
  final num cashAmount;
  final num checkAmount;
  final num ccAmount;
  final num eventSalesCollected;
  final num givebackSubtotal;
  final num salesTax;
  final num giveback;
  final num tipAmount;
  final num netEventSales;
  final num eventSales;
  final num collected;
  final num balance;
  final bool givebackPaid;
  final bool clientInvoice;
  final int givebackSettledDate;
  final int invoiceSettledDate;
  final String givebackCheck;
  final bool thankYouEmail;
  final String eventSalesTypeId;
  final num minimumFee;
  final bool keepCupCount;
  final num cupCountTotal;
  final num packageFee;
  final bool prePay;
  final String contactTitle;
  final String clientIndustriesTypeId;
  final String invoiceCheck;
  final String oldDbEventId;
  final bool confirmedEmailSent;

  Events(
      {required this.id,
      required this.eventCode,
      required this.name,
      required this.startDateTime,
      required this.endDateTime,
      required this.delivery,
      required this.link,
      required this.addressLine1,
      required this.addressLine2,
      required this.country,
      required this.state,
      required this.city,
      required this.zipCode,
      required this.contactName,
      required this.contactEmail,
      required this.contactPhoneNumCountryCode,
      required this.contactPhoneNumber,
      required this.key,
      required this.values,
      required this.displayAdditionalPaymentField,
      required this.additionalPaymentFieldLabel,
      required this.activated,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted,
      required this.franchiseId,
      required this.minimumOrderAmount,
      required this.eventStatus,
      required this.specialInstructionLabel,
      required this.displayGratuityField,
      required this.gratuityFieldLabel,
      required this.campaignId,
      required this.enableDonation,
      required this.donationFieldLabel,
      required this.assetId,
      required this.weatherType,
      required this.paymentTerm,
      required this.secondaryContactName,
      required this.secondaryContactEmail,
      required this.secondaryContactPhoneNumCountryCode,
      required this.secondaryContactPhoneNumber,
      required this.notes,
      required this.eventType,
      required this.preOrder,
      required this.radius,
      required this.timeSlot,
      required this.maxOrderInSlot,
      required this.locationNotes,
      required this.orderAttribute,
      required this.minimumDeliveryTime,
      required this.startAddress,
      required this.useTimeSlot,
      required this.maxAllowedOrders,
      required this.deliveryMessage,
      required this.recipientNameLabel,
      required this.orderStartDateTime,
      required this.orderEndDateTime,
      required this.smsNotification,
      required this.emailNotification,
      required this.clientId,
      required this.recurringType,
      required this.days,
      required this.monthlyDateTime,
      required this.expiryDate,
      required this.lastDayOfMonth,
      required this.seriesId,
      required this.manualStatus,
      required this.entryFee,
      required this.cashAmount,
      required this.checkAmount,
      required this.ccAmount,
      required this.eventSalesCollected,
      required this.givebackSubtotal,
      required this.salesTax,
      required this.giveback,
      required this.tipAmount,
      required this.netEventSales,
      required this.eventSales,
      required this.collected,
      required this.balance,
      required this.givebackPaid,
      required this.clientInvoice,
      required this.givebackSettledDate,
      required this.invoiceSettledDate,
      required this.givebackCheck,
      required this.thankYouEmail,
      required this.eventSalesTypeId,
      required this.minimumFee,
      required this.keepCupCount,
      required this.cupCountTotal,
      required this.packageFee,
      required this.prePay,
      required this.contactTitle,
      required this.clientIndustriesTypeId,
      required this.invoiceCheck,
      required this.oldDbEventId,
      required this.confirmedEmailSent});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "event_code": eventCode,
      "name": name,
      "start_date_time": startDateTime,
      "end_date_time": endDateTime,
      "delivery": delivery,
      "link": link,
      "address_line_1": addressLine1,
      "address_line_2": addressLine2,
      "country": country,
      "state": state,
      "city": city,
      "zip_code": zipCode,
      "contact_name": contactName,
      "contact_email": contactEmail,
      "contact_phone_num_country_code": contactPhoneNumCountryCode,
      "contact_phone_number": contactPhoneNumber,
      "key": key,
      "values": values,
      "display_additional_payment_field": displayAdditionalPaymentField,
      "additional_payment_field_label": additionalPaymentFieldLabel,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "franchise_id": franchiseId,
      "minimum_order_amount": minimumOrderAmount,
      "event_status": eventStatus,
      "special_instruction_label": specialInstructionLabel,
      "display_gratuity_field": displayGratuityField,
      "gratuity_field_label": gratuityFieldLabel,
      "campaign_id": campaignId,
      "enable_donation": enableDonation,
      "donation_field_label": donationFieldLabel,
      "asset_id": assetId,
      "weather_type": weatherType,
      "payment_term": paymentTerm,
      "secondary_contact_name": secondaryContactName,
      "secondary_contact_email": secondaryContactEmail,
      "secondary_contact_phone_num_country_code": secondaryContactPhoneNumCountryCode,
      "secondary_contact_phone_number": secondaryContactPhoneNumber,
      "notes": notes,
      "event_type": eventType,
      "pre_order": preOrder,
      "radius": radius,
      "time_slot": timeSlot,
      "max_order_in_slot": maxOrderInSlot,
      "location_notes": locationNotes,
      "order_attribute": orderAttribute,
      "minimum_delivery_time": minimumDeliveryTime,
      "start_address": startAddress,
      "use_time_slot": useTimeSlot,
      "max_allowed_orders": maxAllowedOrders,
      "delivery_message": deliveryMessage,
      "recipient_name_label": recipientNameLabel,
      "order_start_date_time": orderStartDateTime,
      "order_end_date_time": orderEndDateTime,
      "sms_notification": smsNotification,
      "email_notification": emailNotification,
      "client_id": clientId,
      "recurring_type": recurringType,
      "days": days,
      "monthly_date_time": monthlyDateTime,
      "expiry_date": expiryDate,
      "last_day_of_month": lastDayOfMonth,
      "series_id": seriesId,
      "manual_status": manualStatus,
      "entry_fee": entryFee,
      "cash_amount": cashAmount,
      "check_amount": checkAmount,
      "cc_amount": ccAmount,
      "event_sales_collected": eventSalesCollected,
      "giveback_subtotal": givebackSubtotal,
      "sales_tax": salesTax,
      "giveback": giveback,
      "tip_amount": tipAmount,
      "net_event_sales": netEventSales,
      "event_sales": eventSales,
      "collected": collected,
      "balance": balance,
      "giveback_paid": givebackPaid,
      "client_invoice": clientInvoice,
      "giveback_settled_date": givebackSettledDate,
      "invoice_settled_date": invoiceSettledDate,
      "giveback_check": givebackCheck,
      "thank_you_email": thankYouEmail,
      "event_sales_type_id": eventSalesTypeId,
      "minimum_fee": minimumFee,
      "keep_cup_count": keepCupCount,
      "cup_count_total": cupCountTotal,
      "package_fee": packageFee,
      "pre_pay": prePay,
      "contact_title": contactTitle,
      "client_industries_type_id": clientIndustriesTypeId,
      "invoice_check": invoiceCheck,
      "old_db_event_id": oldDbEventId,
      "confirmed_email_sent": confirmedEmailSent,
    };
  }

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
        id: map["id"],
        eventCode: map["event_code"],
        name: map["name"],
        startDateTime: map["start_date_time"],
        endDateTime: map["end_date_time"],
        delivery: map["delivery"],
        link: map["link"],
        addressLine1: map["address_line_1"],
        addressLine2: map["address_line_2"],
        country: map["country"],
        state: map["state"],
        city: map["city"],
        zipCode: map["zip_code"],
        contactName: map["contact_name"],
        contactEmail: map["contact_email"],
        contactPhoneNumCountryCode: map["contact_phone_num_country_code"],
        contactPhoneNumber: map["contact_phone_number"],
        key: map["key"],
        values: map["values"],
        displayAdditionalPaymentField: map["display_additional_payment_field"]==1,
        additionalPaymentFieldLabel: map["additional_payment_field_label"],
        activated: map["activated"]==1,
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"]==1,
        franchiseId: map["franchise_id"],
        minimumOrderAmount: map["minimum_order_amount"],
        eventStatus: map["event_status"],
        specialInstructionLabel: map["special_instruction_label"],
        displayGratuityField: map["display_gratuity_field"]==1,
        gratuityFieldLabel: map["gratuity_field_label"],
        campaignId: map["campaign_id"],
        enableDonation: map["enable_donation"]==1,
        donationFieldLabel: map["donation_field_label"],
        assetId: map["asset_id"],
        weatherType: map["weather_type"],
        paymentTerm: map["payment_term"],
        secondaryContactName: map["secondary_contact_name"],
        secondaryContactEmail: map["secondary_contact_email"],
        secondaryContactPhoneNumCountryCode: map["secondary_contact_phone_num_country_code"],
        secondaryContactPhoneNumber: map["secondary_contact_phone_number"],
        notes: map["notes"],
        eventType: map["event_type"],
        preOrder: map["pre_order"]==1,
        radius: map["radius"],
        timeSlot: map["time_slot"],
        maxOrderInSlot: map["max_order_in_slot"],
        locationNotes: map["location_notes"],
        orderAttribute: map["order_attribute"],
        minimumDeliveryTime: map["minimum_delivery_time"],
        startAddress: map["start_address"],
        useTimeSlot: map["use_time_slot"]==1,
        maxAllowedOrders: map["max_allowed_orders"],
        deliveryMessage: map["delivery_message"],
        recipientNameLabel: map["recipient_name_label"],
        orderStartDateTime: map["order_start_date_time"],
        orderEndDateTime: map["order_end_date_time"],
        smsNotification: map["sms_notification"]==1,
        emailNotification: map["email_notification"]==1,
        clientId: map["client_id"],
        recurringType: map["recurring_type"],
        days: map["days"],
        monthlyDateTime: map["monthly_date_time"],
        expiryDate: map["expiry_date"],
        lastDayOfMonth: map["last_day_of_month"]==1,
        seriesId: map["series_id"],
        manualStatus: map["manual_status"],
        entryFee: map["entry_fee"],
        cashAmount: map["cash_amount"],
        checkAmount: map["check_amount"],
        ccAmount: map["cc_amount"],
        eventSalesCollected: map["event_sales_collected"],
        givebackSubtotal: map["giveback_subtotal"],
        salesTax: map["sales_tax"],
        giveback: map["giveback"],
        tipAmount: map["tip_amount"],
        netEventSales: map["net_event_sales"],
        eventSales: map["event_sales"],
        collected: map["collected"],
        balance: map["balance"],
        givebackPaid: map["giveback_paid"]==1,
        clientInvoice: map["client_invoice"]==1,
        givebackSettledDate: map["giveback_settled_date"],
        invoiceSettledDate: map["invoice_settled_date"],
        givebackCheck: map["giveback_check"],
        thankYouEmail: map["thank_you_email"]==1,
        eventSalesTypeId: map["event_sales_type_id"],
        minimumFee: map["minimum_fee"],
        keepCupCount: map["keep_cup_count"]==1,
        cupCountTotal: map["cup_count_total"],
        packageFee: map["package_fee"],
        prePay: map["pre_pay"]==1,
        contactTitle: map["contact_title"],
        clientIndustriesTypeId: map["client_industries_type_id"],
        invoiceCheck: map["invoice_check"],
        oldDbEventId: map["old_db_event_id"],
        confirmedEmailSent: map["confirmed_email_sent"]==1);
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    eventCode: $eventCode,
    name: $name,
    startDateTime: $startDateTime,
    endDateTime: $endDateTime,
    delivery: $delivery,
    link: $link,
    addressLine1: $addressLine1, 
    addressLine2: $addressLine2,
    country: $country,
    state: $state,
    city: $city,
    zipCode: $zipCode,
    contactName: $contactName,
    contactEmail: $contactEmail,
    contactPhoneNumCountryCode: $contactPhoneNumCountryCode,
    contactPhoneNumber: $contactPhoneNumber,
    key: $key, 
    values: $values,
    displayAdditionalPaymentField: $displayAdditionalPaymentField,
    additionalPaymentFieldLabel: $additionalPaymentFieldLabel,
    activated: $activated,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,
    franchiseId: $franchiseId, 
    minimumOrderAmount: $minimumOrderAmount,
    eventStatus: $eventStatus,
    specialInstructionLabel: $specialInstructionLabel,
    displayGratuityField: $displayGratuityField,
    gratuityFieldLabel: $gratuityFieldLabel,
    campaignId: $campaignId,
    enableDonation: $enableDonation,
    donationFieldLabel: $donationFieldLabel,
    assetId: $assetId,
    weatherType: $weatherType, 
    paymentTerm: $paymentTerm,
    secondaryContactName: $secondaryContactName,
    secondaryContactEmail: $secondaryContactEmail,
    secondaryContactPhoneNumCountryCode: $secondaryContactPhoneNumCountryCode,
    secondaryContactPhoneNumber: $secondaryContactPhoneNumber,
    notes: $notes,
    eventType: $eventType,
    preOrder: $preOrder,
    radius: $radius,
    timeSlot: $timeSlot, 
    maxOrderInSlot: $maxOrderInSlot,
    locationNotes: $locationNotes,
    orderAttribute: $orderAttribute,
    minimumDeliveryTime: $minimumDeliveryTime,
    startAddress: $startAddress,
    useTimeSlot: $useTimeSlot,
    idmaxAllowedOrders: $maxAllowedOrders,
    deliveryMessage: $deliveryMessage,
    recipientNameLabel: $recipientNameLabel,
    orderStartDateTime: $orderStartDateTime, 
    orderEndDateTime: $orderEndDateTime,
    smsNotification: $smsNotification,
    emailNotification: $emailNotification,
    clientId: $clientId,
    recurringType: $recurringType,
    days: $days,
    monthlyDateTime: $monthlyDateTime,
    expiryDate: $expiryDate,
    lastDayOfMonth: $lastDayOfMonth,
    seriesId: $seriesId, 
    manualStatus: $manualStatus,
    entryFee: $entryFee,
    cashAmount: $cashAmount,
    checkAmount: $checkAmount,
    ccAmount: $ccAmount,
    eventSalesCollected: $eventSalesCollected,
    givebackSubtotal: $givebackSubtotal,
    salesTax: $salesTax,
    giveback: $giveback,
    tipAmount: $tipAmount, 
    netEventSales: $netEventSales,
    eventSales: $eventSales,
    collected: $collected,
    balance: $balance,
    givebackPaid: $givebackPaid,
    clientInvoice: $clientInvoice,
    givebackSettledDate: $givebackSettledDate,
    invoiceSettledDate: $invoiceSettledDate,
    givebackCheck: $givebackCheck,
    thankYouEmail: $thankYouEmail, 
    eventSalesTypeId: $eventSalesTypeId,
    minimumFee: $minimumFee,
    keepCupCount: $keepCupCount,
    cupCountTotal: $cupCountTotal,
    packageFee: $packageFee,
    prePay: $prePay,
    contactTitle: $contactTitle,
    clientIndustriesTypeId: $clientIndustriesTypeId,
    invoiceCheck: $invoiceCheck,
    oldDbEventId: $oldDbEventId,
    confirmedEmailSent:$confirmedEmailSent      
    
    
    ----------------------------------
    """;
  }
}
