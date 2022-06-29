//
//  FinixHelper.swift
//  FinixTest
//
//  Created by Tushar Jadhav on 20/04/22.
//

import Foundation
import FinixPOS

public protocol FinixHelperDelegate : AnyObject {
    
    /// SDK Initialization
    func sdkInitialzed(error: Error?)
    
    /// SDK Deinitialization
    func sdkDeinitialzed(error: Error?)
    
    /// On reader connection.
    /// - Parameter description: descriptor for the device e.g. "BBPOS"
    /// - Parameter model: device model e.g. "CHB20"
    /// - Parameter serialNumber: unique identifer for the device e.g. "CHBXXXXXXXXXXXX"
    func deviceDidConnect(_ description: String, model: String, serialNumber: String)
    
    /// On device disconnection complete.
    func deviceDidDisconnect()
    
    /// On reader initialization.
    /// - Parameter currentProgress: percentage progress
    /// - Parameter description: description for the device e.g. "BBPOS"
    /// - Parameter model: device model e.g. "CHB20"
    /// - Parameter serialNumber: unique identifer for the device e.g. "CHBXXXXXXXXXXXX"    ///
    func deviceInitialization(inProgress currentProgress: Double, description: String, model: String, serialNumber: String)
    
    /// On reader error.
    /// - Parameter error: error generated by the device
    func deviceDidError(_ error: Error)
    
    /// on `DeviceStatus` change
    /// - Parameter status: the `DeviceStatus`
    /// - Parameter description: description of the status change
    func statusDidChange(_ status: FinixPOS.DeviceStatus, description: String)
    
    /// Sent when the battery of the reader is low.
    func onBatteryLow()
    
    /// Recently pre-read data has timed out
    func prereadTimedOut()
    
    /// When text is to be shown to the user. e.g. "Insert, Tap or Swipe Card"
    /// - Parameter text: text to show the user
    func onDisplayText(_ text: String)
    
    /// Inform card removal
    func onRemoveCard()
    
    /// Authorization Performed with Error
    func authorizationResponseFailed(error: Error)
    
    /// Authorization Performed with Success, but check for any error
    func authorizationResponseSuccess(authorizationResponseModel: AuthorizationResponseModel?)
    
    /// Capture Performed with Error
    func captureResponseFailed(error: Error?)
    
    /// Capture Performed with Success, but check for any error
    func captureResponseSuccess(transactionResponseModel: TransactionResponseModel?)
    
    /// Void Performed with Error
    func voidResponseFailed(error: Error?)
    
    /// Void Performed with Success, but check for any error
    func voidResponseSuccess(voidResponseText: String)
}

let FINIXHELPER = FinixHelper.sharedFinixHelper

private let _sharedFinixHelper = FinixHelper()

class FinixHelper {
    
    class var sharedFinixHelper: FinixHelper {
        
        return _sharedFinixHelper
    }
    
    weak var finixHelperDelegate: FinixHelperDelegate?
    
    var deviceId: String = ""
    
    var authorizationResponseModel: AuthorizationResponseModel?
    
    func initializeFinixSDK(environment: FinixPOS.Finix.Environment,
                            userName: String,
                            password: String,
                            application: String,
                            version: String,
                            merchantId: String,
                            deviceID: String,
                            serialNumber: String?) {
        
        let config = FinixConfig(environment: environment,
                                 credentials: Finix.APICredentials(username: userName, password: password),
                                 application: application,
                                 version: version,
                                 merchantId: merchantId,
                                 marketCode: .qsr,
                                 deviceType: .BBPOS,
                                 deviceId: deviceID,
                                 serialNumber: serialNumber)
        
        deviceId = deviceID
        
        let client = FinixClient.shared
        client.delegate = self
        client.interactionDelegate = self
        
        client.syncSDK(config: config) { success, error in
            
            if let delegate = self.finixHelperDelegate {
                
                delegate.sdkInitialzed(error: error)
            }
            
            guard success == true else {
                
                print(items:"==========FinixSDK: failed to initalize with error \(error!)==========")
                
                return
            }
            
            print(items:"==========FinixSDK: initialized successfully.==========")
        }
    }
    
    func deinitializeFinixSDK() {
        
        let client = FinixClient.shared
        
        client.unsyncSDK { error in
            
            if let delegate = self.finixHelperDelegate {
                
                delegate.sdkDeinitialzed(error: error)
            }
            
            print(items:"==========FinixSDK: deinitialized==========")
            
            if error != nil {
                
                print(items:"==========Error Deinitializing SDK: \(String(describing: error?.localizedDescription))==========")
            }
        }
    }
    
    func getAuthorizationResponseModel(receipt: SaleReceipt?, response: AuthorizationResponse) -> AuthorizationResponseModel {
        
        let finixAuthorizationReceipt = FinixAuthorizationReceipt(receipt: receipt)
        
        let finixAuthorizationResponse = FinixAuthorizationResponse(response: response)
        
        let authorizationResponseModel = AuthorizationResponseModel(finixAuthorizationReceipt: finixAuthorizationReceipt,
                                                                    finixAuthorizationResponse: finixAuthorizationResponse)
        
        return authorizationResponseModel
    }
    
    func performaAuthorization(billAmount: Decimal, testTags: ResourceTags) {
        
        // before performing sale, present the user an ActionSheet to adjust the amount.
        // upon submission, show the device's input status.
        let saleAmount = Currency(decimal: billAmount, code: .USD)
        
        let transfer = TransferRequest(deviceId: self.deviceId, amount: saleAmount, tags: testTags)
        
        print(items:"==========Transfer Request: \(transfer)==========")
        
        FinixClient.shared.cardAuthorization(transfer) { response, error in
            
            guard let response = response else {
                
                print(items:"==========Failed with error : \(error!)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.authorizationResponseFailed(error: error!)
                }
                
                return
            }
            
            let responseText = String(describing: response)
            
            if response.success {
                
                let receipt = FinixClient.shared.receipt(for: response)
                
                let receiptText = String(describing: receipt)
                
                self.authorizationResponseModel = self.getAuthorizationResponseModel(receipt: receipt, response: response)
                
                print(items:"==========Success response: \(responseText), Transfer Id: \(response.id)==========")
                print(items:"==========Sale Receipt: \(receiptText)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.authorizationResponseSuccess(authorizationResponseModel: self.authorizationResponseModel)
                }
                
            } else {
                
                print(items:"==========Not Successful response: \(responseText)==========")
                
                self.authorizationResponseModel = self.getAuthorizationResponseModel(receipt: nil, response: response)
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.authorizationResponseSuccess(authorizationResponseModel: self.authorizationResponseModel)
                }
            }
        }
    }
    
    func getTransactionResponseModel(captureResponse: CaptureResponse, tipAmount: Double) -> TransactionResponseModel {
        
        let finixCaptureResponse = FinixCaptureResponse(response: captureResponse)
        
        let transactionResponseModel = TransactionResponseModel(authorizationResponseModel: self.authorizationResponseModel, finixCaptureResponse: finixCaptureResponse, tipAmount: tipAmount)
        
        return transactionResponseModel
    }
    
    func performCapture(authorizationId: String, billAmount: Decimal, tipAmount: Double) {
        
        let saleAmount = Currency(decimal: billAmount, code: .USD)
        
        FinixClient.shared.capture(authorizationId: authorizationId, amount: saleAmount) { response, error in
            
            guard let response = response else {
                
                print(items:"==========Failed with error : \(error!)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.captureResponseFailed(error: error!)
                }
                
                return
            }
            
            let responseText = String(describing: response)
            
            if response.success {
                
                let transactionResponseModel = self.getTransactionResponseModel(captureResponse: response, tipAmount: tipAmount)
                
                print(items:"==========Success capture response: \(responseText), Transfer Id: \(response.id)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.captureResponseSuccess(transactionResponseModel: transactionResponseModel)
                }
                
            } else {
                
                print(items:"==========Not Successful response: \(responseText)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.captureResponseFailed(error: nil)
                }
            }
        }
    }
    
    func performVoid(authorizationId: String) {
                
        FinixClient.shared.voidAuthorization(authorizationId: authorizationId) { response, error in
            
            guard let response = response else {
                
                print(items:"==========Failed with error : \(error!)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.voidResponseFailed(error: error!)
                }
                
                return
            }
            
            let responseText = String(describing: response)
            
            if response.success {
                                
                print(items:"==========Success void response: \(responseText), Trace Id: \(response.id)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.voidResponseSuccess(voidResponseText: responseText)
                }
                
            } else {
                
                print(items:"==========Not Successful response: \(responseText)==========")
                
                if let delegate = self.finixHelperDelegate {
                    
                    delegate.voidResponseFailed(error: nil)
                }
            }
        }
    }
    
    /*func performSale(billAmount: Decimal, testTags: ResourceTags) {
     
     // before performing sale, present the user an ActionSheet to adjust the amount.
     // upon submission, show the device's input status.
     let saleAmount = Currency(decimal: billAmount, code: .USD)
     
     let transfer = TransferRequest(deviceId: self.deviceId, amount: saleAmount, tags: testTags)
     
     print(items:"==========Transfer Request: \(transfer)==========")
     
     FinixClient.shared.cardSale(transfer) { response, error in
     
     guard let response = response else {
     
     print(items:"==========Failed with error : \(error!)==========")
     
     if let delegate = self.finixHelperDelegate {
     
     delegate.saleResponseFailed(error: error!)
     }
     
     return
     }
     
     let responseText = String(describing: response)
     
     if response.success {
     
     let receipt = FinixClient.shared.receipt(for: response)
     
     let receiptText = String(describing: receipt)
     
     let saleResponseReceipt = self.convertSaleReceiptToSaleResponseReceipt(receipt: receipt, response: response)
     
     print(items:"==========Success response: \(responseText), Transfer Id: \(response.id)==========")
     print(items:"==========Sale Receipt: \(receiptText)==========")
     
     if let delegate = self.finixHelperDelegate {
     
     delegate.saleResponseSuccess(saleResponseReceipt: saleResponseReceipt)
     }
     
     } else {
     
     print(items:"==========Not Successful response: \(responseText)==========")
     
     let saleResponseReceipt = self.convertSaleReceiptToSaleResponseReceipt(receipt: nil, response: response)
     
     if let delegate = self.finixHelperDelegate {
     
     delegate.saleResponseSuccess(saleResponseReceipt: saleResponseReceipt)
     }
     }
     }
     }*/
    
    func cancelSale() -> Bool {
        
        return FinixClient.shared.stopCurrentOperation()
    }
    
    func isReaderConnected() -> Bool {
        
        return FinixClient.shared.isReaderConnected()
    }
    
    func isSDKInitialized() -> Bool {
        
        return FinixClient.shared.isInitialized()
    }
}

extension FinixHelper: FinixDelegate {
    
    func deviceDidConnect(_ description: String, model: String, serialNumber: String) {
        
        print(items:"==========Device Did Connect:Description:\(description)model:\(model)serial:\(serialNumber)==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.deviceDidConnect(description, model: model, serialNumber: serialNumber)
        }
    }
    
    func deviceDidDisconnect() {
        
        print(items:"==========Device Did Disconnect==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.deviceDidDisconnect()
        }
    }
    
    func deviceInitialization(inProgress currentProgress: Double, description: String, model: String, serialNumber: String) {
        
        print(items:"==========Device Initialization:\nProgress:\(currentProgress)\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.deviceInitialization(inProgress: currentProgress, description: description, model: model, serialNumber: serialNumber)
        }
    }
    
    func deviceDidError(_ error: Error) {
        
        print(items:"==========Device Did Error: \(error.localizedDescription)==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.deviceDidError(error)
        }
    }
    
    func statusDidChange(_ status: DeviceStatus, description: String) {
        
        print(items:"==========Device Status change:\(status), description:\(description)==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.statusDidChange(status, description: description)
        }
    }
    
    func onBatteryLow() {
        
        print(items:"==========Device Battery Low==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.onBatteryLow()
        }
    }
    
    func prereadTimedOut() {
        
        print(items:"==========Device Preread Time Out==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.prereadTimedOut()
        }
    }
}

extension FinixHelper: FinixClientDeviceInteractionDelegate {
    
    func onDisplayText(_ text: String) {
        
        print(items:"==========On display text: \(text)==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.onDisplayText(text)
        }
    }
    
    func onRemoveCard() {
        
        print(items:"==========Card removed==========")
        
        if let delegate = self.finixHelperDelegate {
            
            delegate.onRemoveCard()
        }
    }
}
