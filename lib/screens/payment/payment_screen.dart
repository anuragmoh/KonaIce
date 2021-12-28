import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int paymentModeType = -1;
  double returnAmount = 0.0;
  double totalAmount = 35.0;
  bool isPaymentDone = false;
  int receiptMode = 1;

  TextEditingController amountReceivedController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int currentIndex = 0;

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          children: [
            CommonWidgets().dashboardTopBar(SizedBox(
              width: MediaQuery.of(context).size.width,
            )),
            Expanded(child: bodyWidget()),
            BottomBarWidget(
              onTapCallBack: onTapBottomListItem,
              accountImageVisibility: false,
              isFromDashboard: false,
            )
            // CommonWidgets().bottomBar(false),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() => Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: bodyWidgetComponent(),
      );

  Widget bodyWidgetComponent() => Row(children: [
        leftSideWidget(),
        rightSideWidget(),
      ]);

  Widget leftSideWidget() => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child:  leftSideTopComponent(totalAmount),
        ),
        // leftSideTopComponent(totalAmount),
        const SizedBox(height: 20.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Expanded(child: leftBodyComponent()),
      ]));

  Widget leftSideTopComponent(double totalAmount) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
             //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 InkWell(
                   onTap: (){
                     Navigator.of(context).pop();
                   },
                   child:  CommonWidgets().image(
                       image: AssetsConstants.backArrow, width: 25.0, height: 25.0),
                 ),
                  const SizedBox(width: 22.0,),
                  Column(
                    children: [
                      CommonWidgets().textWidget(
                          StringConstants.totalAmount,
                          StyleConstants.customTextStyle(
                              fontSize: 12.0,
                              color: getMaterialColor(AppColors.textColor2),
                              fontFamily: FontConstants.montserratMedium)),
                      const SizedBox(
                        height: 2.0,
                      ),
                      CommonWidgets().textWidget(
                          '\$$totalAmount',
                          StyleConstants.customTextStyle(
                              fontSize: 34.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratBold))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 51.0,
              ),
              // Amount to return field
              Visibility(
                visible: isPaymentDone == false && paymentModeType == 0
                    ? true
                    : false,
                child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidgets().textWidget(
                            StringConstants.amountToReturn,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor2),
                                fontFamily: FontConstants.montserratMedium)),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonWidgets().textWidget(
                                '\$',
                                StyleConstants.customTextStyle(
                                    fontSize: 22.0,
                                    color:
                                        getMaterialColor(AppColors.textColor1),
                                    fontFamily:
                                        FontConstants.montserratMedium)),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                    color:
                                        getMaterialColor(AppColors.whiteColor),
                                    border: Border.all(
                                        color: getMaterialColor(
                                            AppColors.primaryColor2))),
                                width: 122.0,
                                height: 42.0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 2.0),
                                    child: TextField(
                                      controller: amountReceivedController,
                                      style: StyleConstants.customTextStyle(
                                          fontSize: 22.0,
                                          color: getMaterialColor(
                                              AppColors.textColor1),
                                          fontFamily:
                                              FontConstants.montserratMedium),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          onAmountEnter(double.parse(value));
                                        }
                                      },
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ]),
                ),
              ),
              // Return Amount
              Visibility(
                visible: isPaymentDone == false && paymentModeType == 0
                    ? true
                    : false,
                child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidgets().textWidget(
                            StringConstants.amountToReturn,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor2),
                                fontFamily: FontConstants.montserratMedium)),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonWidgets().textWidget(
                                '\$',
                                StyleConstants.customTextStyle(
                                    fontSize: 22.0,
                                    color:
                                        getMaterialColor(AppColors.textColor1),
                                    fontFamily:
                                        FontConstants.montserratMedium)),
                            CommonWidgets().textWidget(
                                '$returnAmount',
                                StyleConstants.customTextStyle(
                                    fontSize: 22.0,
                                    color:
                                        getMaterialColor(AppColors.textColor1),
                                    fontFamily:
                                        FontConstants.montserratMedium)),
                          ],
                        )
                      ]),
                ),
              ),
              // Button
              buttonWidget(
                  isPaymentDone == true
                      ? StringConstants.newOrder
                      : StringConstants.proceed,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold)),
            ]),
      );

  Widget buttonWidget(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: isPaymentDone == false ? onTapProceed : onTapNewOrder,
      child: Container(
        decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 28.0),
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }

  Widget leftBodyComponent() => SingleChildScrollView(
        child: Column(children: [
          paymentModeWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color:
                  getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
              thickness: 1,
            ),
          ),
          SingleChildScrollView(child: paymentSuccess('35891456')),
        ]),
      );

  Widget paymentModeWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            paymentModeView(StringConstants.cash, 0, AssetsConstants.cash),
            paymentModeView(
                StringConstants.creditCard, 1, AssetsConstants.creditCard),
            paymentModeView(StringConstants.qrCode, 2, AssetsConstants.qrCode),
          ],
        ),
      );

  Widget paymentModeView(String title, int index, String icon) =>
      GestureDetector(
        onTap: () {
          setState(() {
            paymentModeType = index;
          });
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: paymentModeType == index
                      ? getMaterialColor(AppColors.primaryColor2)
                      : null,
                  border: Border.all(
                      color: getMaterialColor(AppColors.primaryColor2)),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
                child: CommonWidgets()
                    .image(image: icon, width: 25.0, height: 25.0),
              ),
            ),
            const SizedBox(width: 10.0),
            CommonWidgets().textWidget(
                title,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratMedium)),
          ],
        ),
      );

  Widget paymentSuccess(String transactionId) => Column(
        children: [
          const SizedBox(height: 68.0),
          CommonWidgets()
              .image(image: AssetsConstants.success, width: 72.0, height: 72.0),
          const SizedBox(height: 21.0),
          CommonWidgets().textWidget(
              StringConstants.paymentSuccessful,
              StyleConstants.customTextStyle(
                  fontSize: 22.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonWidgets().textWidget(
                '${StringConstants.transactionId}:',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
            CommonWidgets().textWidget(
                transactionId,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
          ]),
          const SizedBox(height: 38.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 135.0),
            child: Divider(
              color:
                  getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
              thickness: 1,
            ),
          ),
          const SizedBox(height: 28.0),
          CommonWidgets().textWidget(
              StringConstants.howWouldYouLikeToReceiveTheReceipt,
              StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(height: 12.0),
          Container(
            width: 203.0,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                    color: getMaterialColor(AppColors.primaryColor2))),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      receiptMode = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      color: receiptMode == 1
                          ? getMaterialColor(AppColors.primaryColor2)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38.0, vertical: 9.0),
                      child: CommonWidgets().textWidget(
                          StringConstants.email,
                          StyleConstants.customTextStyle(
                              fontSize: 9.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratRegular)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      receiptMode = 2;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        color: receiptMode == 2
                            ? getMaterialColor(AppColors.primaryColor2)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19.0, vertical: 9.0),
                        child: CommonWidgets().textWidget(
                            StringConstants.textMessage,
                            StyleConstants.customTextStyle(
                                fontSize: 9.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratRegular)),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19.0),
          receiptMode == 1 ? emailReceiptWidget() : textMessageReceiptWidget(),
        ],
      );

  Widget emailReceiptWidget() => Container(
        width: 253.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: getMaterialColor(AppColors.whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0, left: 4.0),
                      child: TextField(
                        controller: emailController,
                        style: StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratSemiBold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
              child: CommonWidgets().image(
                  image: AssetsConstants.send, width: 25.0, height: 25.0),
            )
          ],
        ),
      );

  Widget textMessageReceiptWidget() => Container(
        width: 253.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: getMaterialColor(AppColors.whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 50.0, child: countryPicker()),
                  Container(
                    width: 1.0,
                    height: 20.0,
                    color: getMaterialColor(AppColors.primaryColor1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0, left: 4.0),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratSemiBold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
              child: CommonWidgets().image(
                  image: AssetsConstants.send, width: 25.0, height: 25.0),
            )
          ],
        ),
      );

  Widget countryPicker() => CountryCodePicker(
        onChanged: (value) {},
        padding: EdgeInsets.zero,
        textStyle: StyleConstants.customTextStyle(
            fontSize: 12.0,
            color: getMaterialColor(AppColors.textColor1),
            fontFamily: FontConstants.montserratMedium),
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: '+91',
        showFlag: false,
        // optional. Shows only country name and flag
        showCountryOnly: true,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      );

  onAmountEnter(double value) {
    if (value > totalAmount) {
      setState(() {
        returnAmount = value - totalAmount;
      });
    } else {
      setState(() {
        returnAmount = 0.0;
      });
    }
  }

  // Right side panel design

  Widget rightSideWidget() => Padding(
    padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
    child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.307,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: getMaterialColor(AppColors.whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 19.0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 11.0),
                        child: CommonWidgets().textView(
                            StringConstants.orderDetails,
                            StyleConstants.customTextStyle(
                                fontSize: 22.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold))),
                    customerNameWidget(customerName: 'Nicholas Gibson'),
                    const SizedBox(height: 7.0),
                    orderDetailsWidget(
                        orderId: 'F001587', orderDate: '03/09/2021 at 06:45 PM'),
                    const SizedBox(height: 8.0),
                    customerDetailsComponent(
                        street: '34 View City: Dublin, NH Zip: 43766',
                        email: 'nic.gibson@mail.com',
                        storeAddress: '7 Gullet City, San Dimas, NY 54356-1822',
                        phone: '+1 528 6568 220'),
                    const SizedBox(height: 10.0),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                          color: getMaterialColor(AppColors.whiteColor),
                          child: itemView()),
                    )),
                    DottedLine(
                        height: 2.0,
                        color: getMaterialColor(AppColors.textColor1)),
                    componentBill(),
                  ]),
            ),
          ),
        ),
  );

  // customer Name
  Widget customerNameWidget({required String customerName}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CommonWidgets().textView(
            '${StringConstants.customerName} - ',
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratRegular)),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold))),
      ]);

  // customer Details
  Widget customerDetailsComponent(
          {required String street,
          required String email,
          required String storeAddress,
          required String phone}) =>
      Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.street}: ',
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            Expanded(
                child: CommonWidgets().textView(
                    street,
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium))),
          ]),
          const SizedBox(height: 8.0),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.email}: ',
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            Expanded(
                child: CommonWidgets().textView(
                    email,
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium))),
          ]),
          const SizedBox(height: 8.0),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.phone}: ',
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            Expanded(
                child: CommonWidgets().textView(
                    phone,
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium))),
          ]),
          const SizedBox(height: 8.0),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.storeAddress}: ',
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            Expanded(
                child: CommonWidgets().textView(
                    storeAddress,
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium))),
          ]),
        ],
      );

  // Widget orderDetails
  Widget orderDetailsWidget(
          {required String orderId, required String orderDate}) =>
      Column(children: [
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderId,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
      ]);

  Widget itemView() => Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemViewListItem('Kiddie', 7, 10.0);
            }),
      ]);

  Widget itemViewListItem(String itemName, int quantity, double amount) =>
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonWidgets().textView(
                itemName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            CommonWidgets().textView(
                "${StringConstants.qty} - $quantity",
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            CommonWidgets().textView(
                "\$$amount",
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
          ]),
          const SizedBox(height: 20.0),
        ],
      );

  Widget componentBill() => Column(
        children: [
          const SizedBox(height: 14.0),
          billTextView(StringConstants.foodCost, 38.0),
          billTextView(StringConstants.salesTax, 2.0),
          billTextView(StringConstants.subTotal, 40),
          billTextView(StringConstants.discount, 5.0),
          billTextView(StringConstants.tip, 0.0),
          //const SizedBox(height: 23.0),
          totalBillView(35.0),
          const SizedBox(height: 22.0),
        ],
      );

  Widget billTextView(String billTitle, double itemAmount) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonWidgets().textView(
                billTitle,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratMedium)),
            Row(
              children: [
                CommonWidgets().textView(
                    "\$",
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
                CommonWidgets().textView(
                    '$itemAmount',
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
          ]),
          const SizedBox(height: 21.0),
        ],
      );

  Widget totalBillView(double totalAmount) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CommonWidgets().textView(
            '${StringConstants.billTotal}:',
            StyleConstants.customTextStyle(
                fontSize: 20.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
        CommonWidgets().textView(
            '\$$totalAmount',
            StyleConstants.customTextStyle(
                fontSize: 24.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
      ]);

  onTapNewOrder() {}

  onTapProceed() {
    setState(() {
      isPaymentDone = true;
    });
  }

  onTapBackButton() {
    Navigator.of(context).pop();
  }
}
