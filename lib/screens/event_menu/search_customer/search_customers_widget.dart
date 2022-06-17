import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/customer/customer_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

import '../../../models/network_model/search_customer/customer_model.dart';

class SearchCustomers extends StatefulWidget {
  Function onTapCustomer;
  SearchCustomers({required this.onTapCustomer, Key? key}) : super(key: key);

  @override
  _SearchCustomersState createState() => _SearchCustomersState();
}

class _SearchCustomersState extends State<SearchCustomers>
    implements ResponseContractor {
  late CustomerPresenter _customerPresenter;

  _SearchCustomersState() {
    _customerPresenter = CustomerPresenter(this);
  }

  bool _isApiProcess = false;

  List<CustomerDetails> _customerList = [];
  TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Loader(
        isCallInProgress: _isApiProcess,
        child: _searchCustomerContainer(context));
    //return searchCustomerContainer(context);
  }

  @override
  void dispose() {
    super.dispose();
    _searchFieldController.dispose();
  }

  Widget _searchCustomerContainer(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _cancelButton(),
          _clearButton(),
        ],
      ),
      _searchTextField(),
      Expanded(child: _searchedCustomerList())
    ]);
  }

  Widget _searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: SizedBox(
        height: 3.3 * SizeConfig.heightSizeMultiplier,
        child: TextField(
          controller: _searchFieldController,
          style: StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratMedium),
          decoration: InputDecoration(
              hintText: StringConstants.searchCustomerNameORNum,
              hintStyle: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColor2,
                  fontFamily: FontConstants.montserratMedium),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.5),
                borderSide: BorderSide(color: AppColors.primaryColor1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.5),
                borderSide: BorderSide(color: AppColors.primaryColor1),
              ),
              contentPadding: const EdgeInsets.only(left: 15.0),
              suffixIcon: Icon(
                Icons.search,
                size: 24.0,
                color: AppColors.primaryColor1,
              )),
          onChanged: _onChangeSearchText,
        ),
      ),
    );
  }

  Widget _searchedCustomerList() {
    return ListView.separated(
        itemCount: _customerList.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 1.0,
            color: AppColors.textColor2,
          );
        },
        itemBuilder: (context, index) {
          return _buildSearchedCustomerTile(index);
        });
  }

  Widget _buildSearchedCustomerTile(int index) {
    return ListTile(
      horizontalTitleGap: 5.0,
      dense: true,
      leading: CircleAvatar(
        radius: 1.5 * SizeConfig.imageSizeMultiplier,
        backgroundImage: const AssetImage(AssetsConstants.defaultProfileImage),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().textWidget(
                _customerList[index].getFullName(),
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratMedium)),
            Visibility(
              visible: (_customerList[index].phoneNum ?? '').isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: CommonWidgets().textWidget(
                    _customerList[index].phoneNum!,
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratRegular)),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _onTapCustomerName(index);
      },
    );
  }

  Widget _clearButton() {
    return GestureDetector(
      onTap: _onTapClearButton,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(
            StringConstants.clear,
            StyleConstants.customTextStyle(
                fontSize: 9.0,
                color: AppColors.textColor5,
                fontFamily: FontConstants.montserratSemiBold)),
      ),
    );
  }

  Widget _cancelButton() {
    return GestureDetector(
      onTap: _onTapCancelButton,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(
            StringConstants.cancel,
            StyleConstants.customTextStyle(
                fontSize: 9.0,
                color: AppColors.textColor5,
                fontFamily: FontConstants.montserratSemiBold)),
      ),
    );
  }

  //Action events
  _onTapCustomerName(int index) {
    widget.onTapCustomer(_customerList[index]);
  }

  _onChangeSearchText(String? inputText) {
    if ((inputText ?? '').length > 2 &&
        (inputText ?? '').length % 2 != 0 &&
        (inputText ?? '').isNotEmpty) {
      _customerListAPI(searchText: inputText!);
    }
    // } else if ((inputText ?? '').length < 3 ) {
    //   setState(() {
    //     customerList.clear();
    //   });
    // }
  }

  _onTapCancelButton() {
    widget.onTapCustomer(null);
  }

  _onTapClearButton() {
    setState(() {
      _searchFieldController.text = '';
      _customerList.clear();
    });
  }

  //API Call

  _customerListAPI({required String searchText}) {
    setState(() {
      _isApiProcess = true;
    });

    _customerPresenter.customerList(searchText);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    // TODO: implement showError
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    // TODO: implement showSuccess
    List<CustomerDetails> list = response;
    setState(() {
      _isApiProcess = false;
      _customerList.clear();
      _customerList.addAll(list);
    });
  }
}
