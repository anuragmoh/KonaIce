
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';

class P2PConnectionManager {

  P2PConnectionManager._privateConstructor();

  static final P2PConnectionManager shared = P2PConnectionManager
      ._privateConstructor();

  late NearbyService nearbyService;
  late StreamSubscription subscription;
  Device? connectedDevice;
  String userName= "";

  startService({required bool isStaffView}) async {
    nearbyService = NearbyService();
    String userID = await FunctionalUtils.getUserID();
     userName = await FunctionalUtils.getUserName();

    await nearbyService.init(serviceType: "mpconn",
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
            }
          }
        }
    );
  }

  Future<List<Device>> getDeviceList(Function sentBackValue) async {
    List<Device> devices = [];
    subscription = nearbyService.stateChangedSubscription(callback: (devicesList) {
      for (var element in devicesList) {
        // debugPrint(
        //     " deviceId: ${element.deviceId} | deviceName: ${element
        //         .deviceName} | state: ${element.state}");

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
      //debugPrint("${devices.length}");
      sentBackValue(devices);
    });
    return devices;
  }

  setConnectedDevice(Device device) {
    // debugPrint("set Connection function Call----${device.state}");
    connectedDevice = device;
  }

  connectWithDevice(Device device) {
    // debugPrint("connectWithDevice function call----${device.state}");
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

}