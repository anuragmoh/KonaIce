///
/// \file VPDDelegate.h
///

#ifndef VPDDeviceDelegate_h
#define VPDDeviceDelegate_h

#import "VPDDevice.h"
#import "VTPBluetoothDevice.h"

#ifndef DOXYGEN_SHOULD_SKIP_THIS

///
/// \protocol VPDDelegate
///
/// \brief Protocol for the device notifications
///
/// The VPDDelegate protocol defines the methods a receiver may implement for device notifications.
///
@protocol VPDDelegate

@optional

///
/// \brief Device connected
///
/// Tells the delegate a recognized device has been connected.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
/// \param description The description of the device connected.
///
/// \param serialNumber The serial number of the device connected. This value may be nil if the connected device does not supply this value. In some cases, this value may not be available immediately upon connection.
///
-(void)deviceDidConnect:(NSObject<VPDDevice> *)device description:(NSString *)description model:(NSString *)model serialNumber:(NSString *)serialNumber;

///
/// \brief Device connected
///
/// Tells the delegate a recognized device has been connected.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
/// \param description The description of the device connected.
///
/// \param serialNumber The serial number of the device connected. This value may be nil if the connected device does not supply this value. In some cases, this value may not be available immediately upon connection.
///
/// \param firmwareVersion The firmware vesion of the connected device.
///
/// \param configurationVersion The configuration version of the connected device.
///
///
-(void)deviceDidConnect:(NSObject<VPDDevice> *)device description:(NSString *)description model:(NSString *)model serialNumber:(NSString *)serialNumber firmwareVersion:(NSString*) firwareVersion configurationVersion:(NSString*) configurationVersion;


///
/// \brief Device disconnected
///
/// Tells the delegate the device has been disconnected.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
-(void)deviceDidDisconnect:(NSObject<VPDDevice> *)device;

///
/// \brief Device generated an error
///
/// Tells the delegate the device generated an error. This notification is only generated for errors occuring outside specific functionality supplied by the device.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
/// \param error The error.
///
-(void)deviceDidError:(NSObject<VPDDevice> *)device error:(NSError *)error;

///
/// \brief Device initialized
///
/// Tells the delegate the device initialized. This notification is only generated for errors occuring outside specific functionality supplied by the device.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
/// \param error The error.
///
-(void)deviceDidInitialize:(NSObject<VPDDevice> *)device;

//
/// \brief Device initializatin in progress.
///
/// Updated the delegate on the progress of device initialization.
///
/// \param currentProgress Percent complete of device initialization.
///
/// \param device An NSObject representing a device that implements at minimum the VPDDevice protocol.
///
/// \param error The error.
///
-(void) deviceInitializationInProgress:(double) currentProgress device:(NSObject<VPDDevice> *)device currentStep:(NSString*) currentStep;


//
/// \brief Returns list of scanned devices.
///
/// Returns a list of the available devices of the specified device type in the configuration.
///
/// \param devices List of identifiers of available devices.
///
-(void) onReturnBluetoothScanResults:(NSArray<VTPBluetoothDevice*>*) devices;


@end

#endif /* !DOXYGEN_SHOULD_SKIP_THIS */

#endif /* VPDDeviceDelegate_h */
