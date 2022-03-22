import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';

import 'p2p_models/p2p_order_details_model.dart';

abstract class P2PContractor {
  void receivedDataFromP2P(P2PDataModel response);
}

class P2PConnectionManager {

  P2PConnectionManager._privateConstructor();
  late P2PContractor _view;

  static final P2PConnectionManager shared = P2PConnectionManager
      ._privateConstructor();

  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  bool isServiceStarted = false;
  Device? connectedDevice;
  String userName= "";

  getP2PContractor(P2PContractor view) {
    _view = view ;
  }

  startService({required bool isStaffView}) async {
    nearbyService = NearbyService();
    String userID = await FunctionalUtils.getUserID();
     userName = await FunctionalUtils.getUserName();
    isServiceStarted = true;

    await nearbyService.init(serviceType: "kona-connection",
        deviceName: userName,
        strategy: Strategy.P2P_POINT_TO_POINT,
        callback: (isRunning) async {
          if (isRunning) {
            if (isStaffView) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();

              getDeviceListAtCustomer();
            }
          }
        }
    );

    configureDataSubscription();

  }

  Future<List<Device>> getDeviceList(Function sentBackValue) async {
    List<Device> devices = [];
    subscription = nearbyService.stateChangedSubscription(callback: (devicesList) {
      for (var element in devicesList) {


        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
      }
      devices.clear();
      devices.addAll(devicesList.where((element) => element.deviceName == userName).toList());
      var connectedDevices = devices.where((device) => device.state == SessionState.connected).toList();
      if (connectedDevices.isNotEmpty) {
        setConnectedDevice(connectedDevices[0]);
      }
      sentBackValue(devices);
    });
    return devices;
  }

  getDeviceListAtCustomer() {
    getDeviceList((deviceList) => {});
  }

  configureDataSubscription() {
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          if (data != null) {
            var dataObjectEncoded = jsonEncode(data);
            Map<String, dynamic> dataObject = json.decode(dataObjectEncoded);
            P2PDataModel dataObjectP2P = p2PDataModelFromJson(dataObject['message']);
            _receivedData(dataObjectP2P);
          }
  });
  }

  setConnectedDevice(Device device) {
    // debugPrint("set Connection function Call----${device.state}");
    connectedDevice = device;
  }

  connectWithDevice(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }


  _sendData(String text) {
    if (connectedDevice != null && connectedDevice!.state == SessionState.connected) {
      nearbyService.sendMessage(connectedDevice!.deviceId, text);
      debugPrint("-----------data sent-------------------");
    } else {
      debugPrint("-----------connection Lost-------------");
      if (connectedDevice != null) {
        debugPrint("---------Auto connect------");
        connectWithDevice(connectedDevice!);
      }
    }
  }

  _receivedData(P2PDataModel data) async {
    var selectedMode = await SessionDAO().getValueForKey(DatabaseKeys.selectedMode);
    bool isStaffView = (selectedMode != null && selectedMode.value == StringConstants.staffMode);

    if (isStaffView) {
      dataReceivedAtStaff(data);
    } else {
      dataReceivedAtCustomer(data);
    }
  }


  updateData({required String action, String data = ''}) async {
    var selectedMode = await SessionDAO().getValueForKey(DatabaseKeys.selectedMode);
    bool isStaffView = (selectedMode != null && selectedMode.value == StringConstants.staffMode);

    if (isStaffView) {
      notifyChangeToCustomer(action: action, data: data);
    } else {
      notifyChangeToStaff(action: action, data: data);
    }
  }

  updateDataWithObject({required String action, required dynamic dataObject}) {
    String dataStr = StringExtension.empty();
     if (action == StaffActionConst.orderModelUpdated) {
       P2POrderDetailsModel model = dataObject as P2POrderDetailsModel ;
       dataStr = p2POrderDetailsModelToJson(model);
     }

     updateData(action: action, data: dataStr);

  }


  notifyChangeToCustomer({required String action, required String data}) {
    P2PDataModel dataObject =  P2PDataModel(action: action, data: data);
    String dataInStr = p2PDataModelToJson(dataObject);
    _sendData(dataInStr);
  }

  notifyChangeToStaff({required String action, required String data}) {
    P2PDataModel dataObject =  P2PDataModel(action: action, data: data);
    String dataInStr = p2PDataModelToJson(dataObject);

    _sendData(dataInStr);
  }


  //Received Data
  dataReceivedAtCustomer(P2PDataModel data) {

      _view.receivedDataFromP2P(data);
  }

  dataReceivedAtStaff(P2PDataModel data) {
     _view.receivedDataFromP2P(data);
  }


}