

import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class EventsDAO {
  static const String tableName = "events";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(Events events) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (created_at, updated_by, updated_at, deleted, franchise_id, minimum_order_amount, event_status, special_instruction_label, display_gratuity_field, gratuity_field_label, campaign_id, enable_donation, donation_field_label, asset_id, weather_type, payment_term, secondary_contact_name, secondary_contact_email, secondary_contact_phone_num_country_code, secondary_contact_phone_number, notes, event_type, pre_order, radius, time_slot, max_order_in_slot, location_notes, order_attribute, minimum_delivery_time, start_address, use_time_slot, max_allowed_orders, delivery_message, recipient_name_label, order_start_date_time, order_end_date_time, sms_notification, email_notification, client_id, recurring_type, days, monthly_date_time, expiry_date, last_day_of_month, series_id, manual_status, entry_fee, cash_amount, check_amount, cc_amount, event_sales_collected, giveback_subtotal, sales_tax, giveback, tip_amount, net_event_sales, event_sales, collected, balance, giveback_paid, client_invoice, giveback_settled_date, invoice_settled_date, giveback_check, thank_you_email, event_sales_type_id, minimum_fee, keep_cup_count, cup_count_total, package_fee, pre_pay, contact_title, client_industries_type_id, invoice_check, old_db_event_id, confirmed_email_sent)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [events.id, events.eventCode, events.name, events.startDateTime, events.endDateTime, events.delivery, events.link, events.addressLine1, events.addressLine2, events.country, events.state, events.city, events.zipCode, events.contactName, events.contactEmail, events.contactPhoneNumCountryCode, events.contactPhoneNumber, events.key, events.value, events.displayAdditionalPaymentField, events.additionalPaymentFieldLabel, events.activated, events.createdBy, events.createdAt, events.updatedBy, events.updatedAt, events.deleted, events.franchiseId, events.minimumOrderAmount, events.eventStatus, events.specialInstructionLabel, events.displayGratuityField, events.gratuityFieldLabel, events.campaignId, events.enableDonation, events.donationFieldLabel, events.assetId, events.weatherType, events.paymentTerm, events.secondaryContactName, events.secondaryContactEmail, events.secondaryContactPhoneNumCountryCode, events.secondaryContactPhoneNumber, events.notes, events.eventType, events.preOrder, events.radius, events.timeSlot, events.maxOrderInSlot, events.locationNotes, events.orderAttribute, events.minimumDeliveryTime, events.startAddress, events.useTimeSlot, events.maxAllowedOrders, events.deliveryMessage, events.recipientNameLabel, events.orderStartDateTime, events.orderEndDateTime, events.smsNotification, events.emailNotification, events.clientId, events.recurringType, events.days, events.monthlyDateTime, events.expiryDate, events.lastDayOfMonth, events.seriesId, events.manualStatus, events.entryFee, events.cashAmount, events.checkAmount, events.ccAmount, events.eventSalesCollected, events.givebackSubtotal, events.salesTax, events.giveback, events.tipAmount, events.netEventSales, events.eventSales, events.collected, events.balance, events.givebackPaid, events.clientInvoice, events.givebackSettledDate, events.invoiceSettledDate, events.givebackCheck, events.thankYouEmail, events.eventSalesTypeId, events.minimumFee, events.keepCupCount, events.cupCountTotal, events.packageFee, events.prePay, events.contactTitle, events.clientIndustriesTypeId, events.invoiceCheck, events.oldDbEventId, events.confirmedEmailSent]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<Events?> getValues() async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return Events.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearEventsData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}