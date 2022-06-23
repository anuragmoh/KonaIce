import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/utils/color_extension.dart';

import '../../constants/app_colors.dart';
import '../../constants/font_constants.dart';
import '../../constants/string_constants.dart';
import '../../constants/style_constants.dart';
import '../../utils/common_widgets.dart';
import '../constants/asset_constants.dart';
import '../utils/loader.dart';
import '../utils/p2p_utils/bonjour_utils.dart';
import '../utils/size_configuration.dart';

// ignore: must_be_immutable
class ReconnectScreenDialog extends StatefulWidget {
  Function callBack;
  ReconnectScreenDialog({Key? key, required this.callBack}) : super(key: key);
  @override
  State<ReconnectScreenDialog> createState() => _ReconnectScreenDialogState();
}

class _ReconnectScreenDialogState extends State<ReconnectScreenDialog> {
  List<Device> deviceList = [];
  getAvailableDevice() {
    P2PConnectionManager.shared.startService(isStaffView: true);
    P2PConnectionManager.shared.getDeviceList(getBackValue);
  }

  bool isConnectionProcess = false;
  bool isConnected = false;
  getBackValue(dynamic value) {
    setState(() {
      deviceList.clear();
      deviceList.addAll(value);
    });
    // debugPrint("It's back with value${deviceList.length}");
  }

  @override
  void initState() {
    super.initState();
    getAvailableDevice();
  }

  @override
  Widget build(BuildContext context) {
    return showReconnectDialog();
  }

  Widget showReconnectDialog() {
    return Dialog(
      backgroundColor: AppColors.whiteColor.toMaterialColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child:
          Loader(isCallInProgress: isConnectionProcess, child: bodyContainer()),
    );
  }

  Widget bodyContainer() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41, vertical: 25),
              child: Text(
                StringConstants.allDeviceScreenHead,
                textAlign: TextAlign.center,
                style: StyleConstants.customTextStyle(
                    fontSize: 22.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratSemiBold),
              ),
            ),
            Expanded(
              child: deviceList.isNotEmpty
                  ? ListView.builder(
                      itemCount: deviceList.length,
                      itemBuilder: (context, index) {
                        final device = deviceList[index];
                        return listView(device);
                      })
                  : Align(
                      alignment: Alignment.center,
                      child: CommonWidgets().textWidget(
                          StringConstants.noDeviceAvailableToConnect,
                          StyleConstants.customTextStyle(
                              fontSize: 20.0,
                              color: AppColors.textColor1,
                              fontFamily: FontConstants.montserratSemiBold))),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: doneButton(
                  StringConstants.done,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1.toMaterialColor(),
                      fontFamily: FontConstants.montserratBold)),
            )
          ],
        ),
      );
  Widget icon() {
    return CommonWidgets().image(
        image: AssetsConstants.konaIcon,
        width: 20.96 * SizeConfig.imageSizeMultiplier,
        height: 15.62 * SizeConfig.imageSizeMultiplier);
  }

  Widget listView(Device device) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CommonWidgets().image(
                    image: AssetsConstants.tabletIcon,
                    width: 1.56 * SizeConfig.imageSizeMultiplier,
                    height: 2.08 * SizeConfig.imageSizeMultiplier),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceName,
                      textAlign: TextAlign.left,
                      style: StyleConstants.customTextStyle(
                          fontSize: 15,
                          color: AppColors.textColor1.toMaterialColor(),
                          fontFamily: FontConstants.montserratMedium),
                    ),
                    Text('(${getStateName(device.state)})',
                        textAlign: TextAlign.left,
                        style: StyleConstants.customTextStyle(
                            fontSize: 13,
                            color: getStateColor(device.state),
                            fontFamily: FontConstants.montserratMedium)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onButtonClicked(device),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    color: getButtonColor(device.state),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Text(
                      getButtonStateName(device.state),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Divider(),
          ),
        ],
      );
  Widget doneButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: () {
        onTapDoneButton();
      },
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: AppColors.primaryColor2.toMaterialColor(),
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
  onTapDoneButton() {
    widget.callBack(isConnected);
    Navigator.of(context).pop();
    // Navigator.pop(context);
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        debugPrint('not connected');
        isConnectionProcess = false;
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        isConnectionProcess = false;
        debugPrint('connected');
        return "connected";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return AppColors.textColor5.toMaterialColor();
      case SessionState.connecting:
        return AppColors.textColor2.toMaterialColor();
      default:
        return AppColors.textColor7.toMaterialColor();
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        P2PConnectionManager.shared.connectWithDevice(device);
        setState(() {
          debugPrint('state changed');
          isConnectionProcess = true;
          isConnected = true;
        });
        break;
      case SessionState.connected:
        P2PConnectionManager.shared.connectWithDevice(device);
        setState(() {
          isConnected = false;
        });
        break;
      case SessionState.connecting:
        break;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return AppColors.denotiveColor2.toMaterialColor();
      default:
        return AppColors.denotiveColor1.toMaterialColor();
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }
}
