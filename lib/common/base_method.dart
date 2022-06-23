import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../constants/string_constants.dart';
import '../database/daos/events_dao.dart';
import '../models/data_models/sync_event_menu.dart';
import '../network/repository/payment/payment_presenter.dart';

class BaseMethod {
  String menuName = StringConstants.customMenuPackage;
  bool isEditingMenuName = false;
  var amountTextFieldController = TextEditingController();
  var menuNameTextFieldController = TextEditingController();
  String cardNumberValidationMessage = "";
  String cardDateValidationMessage = "";
  String cardCvvValidationMessage = "";
  String cardNumber = "4111111111111111",
      cardCvc = "123",
      cardExpiryYear = "22",
      cardExpiryMonth = "12";
  String stripeTokenId = "", stripePaymentMethodId = "";
  String demoCardNumber = "";
  bool isCardNumberValid = false;
  bool isExpiryValid = false;
  bool isCvcValid = false;
  bool isApiProcess = false;
  late PaymentPresenter paymentPresenter;
  TextEditingController dateExpiryController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

  Future<void> insertData(
      List<POsSyncEventDataDtoList> pOsSyncEventDataDtoList) async {
    for (int i = 0; i < pOsSyncEventDataDtoList.length; i++) {
      await EventsDAO().insert(Events(
          id: pOsSyncEventDataDtoList[i].eventId!,
          eventCode: pOsSyncEventDataDtoList[i].eventCode!,
          name: pOsSyncEventDataDtoList[i].name!,
          startDateTime: pOsSyncEventDataDtoList[i].startDateTime!,
          endDateTime: pOsSyncEventDataDtoList[i].endDateTime!,
          delivery: "empty",
          link: "empty",
          addressLine1: pOsSyncEventDataDtoList[i].addressLine1!,
          addressLine2: pOsSyncEventDataDtoList[i].addressLine2 ?? "",
          country: pOsSyncEventDataDtoList[i].country!,
          state: pOsSyncEventDataDtoList[i].state!,
          city: pOsSyncEventDataDtoList[i].city!,
          zipCode: pOsSyncEventDataDtoList[i].zipCode!,
          contactName: "empty",
          contactEmail: "empty",
          contactPhoneNumCountryCode: "empty",
          contactPhoneNumber: "empty",
          key: "empty",
          values: "empty",
          displayAdditionalPaymentField: false,
          additionalPaymentFieldLabel: "empty",
          activated: false,
          createdBy: pOsSyncEventDataDtoList[i].createdBy!,
          createdAt: pOsSyncEventDataDtoList[i].createdAt!,
          updatedBy: pOsSyncEventDataDtoList[i].updatedBy!,
          updatedAt: pOsSyncEventDataDtoList[i].updatedAt!,
          deleted: pOsSyncEventDataDtoList[i].deleted!,
          franchiseId: "empty",
          minimumOrderAmount: 0.0,
          eventStatus: "empty",
          specialInstructionLabel: "empty",
          displayGratuityField: false,
          gratuityFieldLabel: "empty",
          campaignId: "empty",
          enableDonation: false,
          donationFieldLabel: "empty",
          assetId: "empty",
          weatherType: "empty",
          paymentTerm: "empty",
          secondaryContactName: "empty",
          secondaryContactEmail: "empty",
          secondaryContactPhoneNumCountryCode: "empty",
          secondaryContactPhoneNumber: "empty",
          notes: "empty",
          eventType: "empty",
          preOrder: false,
          radius: 0,
          timeSlot: 0,
          maxOrderInSlot: 0,
          locationNotes: "empty",
          orderAttribute: "empty",
          minimumDeliveryTime: 0,
          startAddress: "empty",
          useTimeSlot: false,
          maxAllowedOrders: 0,
          deliveryMessage: "empty",
          recipientNameLabel: "empty",
          orderStartDateTime: 0,
          orderEndDateTime: 0,
          smsNotification: false,
          emailNotification: false,
          clientId: "empty",
          recurringType: "empty",
          days: "empty",
          monthlyDateTime: 0,
          expiryDate: 0,
          lastDayOfMonth: false,
          seriesId: "empty",
          manualStatus: "empty",
          entryFee: 0,
          cashAmount: 0,
          checkAmount: 0,
          ccAmount: 0,
          eventSalesCollected: 0,
          salesTax: pOsSyncEventDataDtoList[i].salesTax ?? 0,
          giveback: 0,
          tipAmount: 0,
          netEventSales: 0,
          eventSales: 0,
          collected: 0,
          balance: 0,
          givebackPaid: false,
          clientInvoice: false,
          givebackSettledDate: 0,
          invoiceSettledDate: 0,
          givebackCheck: "empty",
          thankYouEmail: false,
          eventSalesTypeId: "empty",
          minimumFee: 0,
          keepCupCount: false,
          cupCountTotal: 0,
          packageFee: 0,
          prePay: false,
          contactTitle: "empty",
          clientIndustriesTypeId: "empty",
          invoiceCheck: "string",
          oldDbEventId: "string",
          confirmedEmailSent: false,
          givebackSubtotal: 0));
    }
  }
}
