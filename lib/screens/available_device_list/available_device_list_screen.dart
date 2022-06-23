import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';

import '../../utils/size_configuration.dart';

class AvailableDeviceListScreen extends StatefulWidget {
  const AvailableDeviceListScreen({Key? key}) : super(key: key);

  @override
  _AvailableDeviceListScreenState createState() =>
      _AvailableDeviceListScreenState();
}

class _AvailableDeviceListScreenState extends State<AvailableDeviceListScreen> {
  List<Device> _deviceList = [];

  _getAvailableDevice() {
    P2PConnectionManager.shared.startService(isStaffView: true);
    P2PConnectionManager.shared.getDeviceList(getBackValue);
  }

  bool _isConnectionProcess = false;

  getBackValue(dynamic value) {
    setState(() {
      _deviceList.clear();
      _deviceList.addAll(value);
    });
    // debugPrint("It's back with value${deviceList.length}");
  }

  @override
  void initState() {
    super.initState();
    _getAvailableDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
        isCallInProgress: _isConnectionProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.primaryColor1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 6.77 * SizeConfig.imageSizeMultiplier,
                  bottom: 5.07 * SizeConfig.imageSizeMultiplier),
              child: _icon(),
            ),
            _bodyContainer(),
            // loginContainer(),
          ],
        ),
      ),
    );
  }

  Widget _bodyContainer() => Container(
        width: 360,
        height: MediaQuery.of(context).size.height * 0.65,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41, vertical: 25),
              child: Text(
                StringConstants.allDeviceScreenHead,
                textAlign: TextAlign.center,
                style: StyleConstants.customTextStyle22MontserratSemiBold(
                    color: AppColors.textColor1),
              ),
            ),
            Expanded(
              child: _deviceList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _deviceList.length,
                      itemBuilder: (context, index) {
                        final device = _deviceList[index];
                        return _listView(device);
                      })
                  : Align(
                      alignment: Alignment.center,
                      child: CommonWidgets().textWidget(
                          StringConstants.noDeviceAvailableToConnect,
                          StyleConstants.customTextStyle20MontserratSemiBold(
                              color: AppColors.textColor1))),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: _proceedButton(
                  StringConstants.proceed,
                  StyleConstants.customTextStyle12MontserratBold(
                      color: AppColors.textColor1)),
            )
          ],
        ),
      );
  Widget _icon() {
    return CommonWidgets().image(
        image: AssetsConstants.konaIcon,
        width: 20.96 * SizeConfig.imageSizeMultiplier,
        height: 15.62 * SizeConfig.imageSizeMultiplier);
  }

  Widget _listView(Device device) => Column(
        children: [
          _buildPad(device),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Divider(),
          ),
        ],
      );

  Padding _buildPad(Device device) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildRow(device),
    );
  }

  Row _buildRow(Device device) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CommonWidgets().image(
            image: AssetsConstants.tabletIcon,
            width: 1.56 * SizeConfig.imageSizeMultiplier,
            height: 2.08 * SizeConfig.imageSizeMultiplier),
      ),
      _buildExpanded(device),
      _buildGestureDetector(device),
    ]);
  }

  GestureDetector _buildGestureDetector(Device device) {
    return GestureDetector(
      onTap: () => _onButtonClicked(device),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        height: 35,
        width: 100,
        decoration: BoxDecoration(
          color: _getButtonColor(device.state),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            _getButtonStateName(device.state),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Expanded _buildExpanded(Device device) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.deviceName,
            textAlign: TextAlign.left,
            style: StyleConstants.customTextStyle15MonsterMedium(
                color: AppColors.textColor1),
          ),
          Text('(${_getStateName(device.state)})',
              textAlign: TextAlign.left,
              style: StyleConstants.customTextStyle15MonsterMedium(
                  color: _getStateColor(device.state))),
        ],
      ),
    );
  }

  Widget _proceedButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: () {
        _onTapProceedButton();
      },
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: AppColors.primaryColor2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70.0),
          child: Align(
              alignment: Alignment.center,
              child: CommonWidgets().textWidget(buttonText, textStyle)),
        ),
      ),
    );
  }

  //Action Event
  _onTapProceedButton() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  String _getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        debugPrint('not connected');
        _isConnectionProcess = false;
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        _isConnectionProcess = false;
        debugPrint('connected');
        return "connected";
    }
  }

  Color _getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return AppColors.textColor5;
      case SessionState.connecting:
        return AppColors.textColor2;
      default:
        return AppColors.textColor7;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        P2PConnectionManager.shared.connectWithDevice(device);
        setState(() {
          debugPrint('state changed');
          _isConnectionProcess = true;
        });
        break;
      case SessionState.connected:
        P2PConnectionManager.shared.connectWithDevice(device);
        break;
      case SessionState.connecting:
        break;
    }
  }

  Color _getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return AppColors.denotiveColor2;
      default:
        return AppColors.denotiveColor1;
    }
  }

  String _getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }
}
