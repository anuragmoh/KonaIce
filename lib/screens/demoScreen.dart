import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/network/repository/payment/strip_token_model.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> implements ResponseContractor {
  late PaymentPresenter paymentPresenter;
  _DemoScreenState(){
    paymentPresenter=PaymentPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('DemoScreen'),
      ),
      body: Container(
        child: Center(
          child:
              ElevatedButton(child: Text('GetToken'), onPressed: getTokenCall),
        ),
      ),
    );
  }

  void getTokenCall() {
    final body = {
      "type":"card",
      "card[number]":"4111111111111111",
      "card[cvc]":"123",
      "card[exp_month]":"12",
      "card[exp_year]":"22"};

    paymentPresenter.getPaymentMethod(body);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    debugPrint('Error');
  }

  @override
  void showSuccess(response) {
    debugPrint('Success');
  }
}
