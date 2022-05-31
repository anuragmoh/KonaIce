import 'package:flutter/material.dart';
import 'package:kona_ice_pos/utils/dialog/confirmation_dialog.dart';
import 'package:kona_ice_pos/utils/dialog/new_order_confirmation_dialog.dart';

class DialogHelper {
  static confirmationDialog(context, onTapYes, onTapNo,confirmMessage) => showDialog(
      context: context,
      builder: (context) =>
          ConfirmationDialog(onTapYes: onTapYes, onTapNo: onTapNo,confirmMessage: confirmMessage,));
  static newOrderConfirmationDialog(context, onTapSave, onTapCancel) =>
      showDialog(
          context: context,
          builder: (context) => NewOrderConfirmationDialog(
              onTapSave: onTapSave, onTapCancel: onTapCancel));
}
