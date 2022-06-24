//
//  SaleResponseReceipt.swift
//  Runner
//
//  Created by Tushar Jadhav on 02/05/22.
//

import Foundation
import FinixPOS

public struct TransactionResponseModel: Codable {
        
    let authorizationResponseModel: AuthorizationResponseModel?
    let finixCaptureResponse: FinixCaptureResponse
    let tipAmount: Double?
}

public struct AuthorizationResponseModel: Codable {
        
    let finixAuthorizationReceipt: FinixAuthorizationReceipt?
    let finixAuthorizationResponse: FinixAuthorizationResponse
}

struct FinixAuthorizationReceipt: Codable {
    
    let merchantName, merchantAddress, applicationLabel, applicationIdentifier, merchantId, referenceNumber, accountNumber, cardBrand, entryMode, transactionId, approvalCode, responseCode, responseMessage, cryptogram, transactionType: String?
    
    let date: Double?
    
    init(receipt: SaleReceipt?) {
        
        merchantName = receipt?.merchantName ?? ""
        merchantAddress = receipt?.merchantAddress ?? ""
        date = receipt?.date.timeIntervalSince1970
        applicationLabel = receipt?.applicationLabel ?? ""
        applicationIdentifier = receipt?.applicationIdentifier ?? ""
        merchantId = receipt?.merchantId ?? ""
        referenceNumber = receipt?.referenceNumber ?? ""
        accountNumber = receipt?.accountNumber ?? ""
        cardBrand = receipt?.cardBrand ?? ""
        entryMode = receipt?.entryMode ?? ""
        transactionId = receipt?.transactionId ?? ""
        approvalCode = receipt?.approvalCode ?? ""
        responseCode = receipt?.responseCode ?? ""
        responseMessage = receipt?.responseMessage ?? ""
        cryptogram = receipt?.cryptogram ?? ""
        transactionType = receipt?.transactionType ?? ""
    }
}

struct FinixAuthorizationResponse: Codable {

    var transferId, traceId: String?
    var transferState: String?
    var amount: Double?
    var created, updated: Double?
    var resourceTags: [String: String]?
    
    /// the entry mode
    var entryMode: String?
    
    /// the masked account number
    var maskedAccountNumber: String?
    
    /// the card logo, e.g.
    var cardLogo: String?
    
    /// the card holder's name
    var cardHolderName: String?
    
    /// the expiry month
    var expirationMonth: String?
    
    /// the expiry year
    var expirationYear: String?
    
    /// AID from a Magstripe-Mode contactless transaction
    var applicationIdentifier: String?
    
    /// Card verification information
    var verification: String?

    /// EMV
    var emv: String?

    /// host response data
    var hostResponse: String?
    
    init(response: AuthorizationResponse) {
        
        transferId = response.id
        traceId = response.traceId
        transferState = self.getFinixTransferState(state: response.state)
        amount = Double(truncating: response.amount.decimal as NSNumber)
        created = response.created.timeIntervalSince1970
        updated = response.updated.timeIntervalSince1970
        resourceTags = response.tags
        entryMode = self.getFinixCardEntryMode(entryMode: response.card.entryMode!)
        maskedAccountNumber = response.card.maskedAccountNumber
        cardLogo = self.getFinixCardLogo(logo: response.card.cardLogo!)
        cardHolderName = response.card.cardHolderName
        expirationMonth = response.card.expirationMonth
        expirationYear = response.card.expirationYear
        applicationIdentifier = response.card.applicationIdentifier
        verification = response.verification?.description
        emv = response.emv.description
        hostResponse = response.hostResponse?.description
    }
    
    func getFinixTransferState(state: Transfer.State) -> String? {
        
        var finixTransferState: String = ""
        
        switch state {
            
        case .pending:
            finixTransferState = FinixTransferState.pending.rawValue
            
        case .canceled:
            finixTransferState = FinixTransferState.canceled.rawValue
            
        case .failed:
            finixTransferState = FinixTransferState.failed.rawValue
            
        case .succeeded:
            finixTransferState = FinixTransferState.succeeded.rawValue
            
        case .unknown:
            finixTransferState = FinixTransferState.unknown.rawValue
            
        @unknown default:
            finixTransferState = FinixTransferState.unknown.rawValue
        }
        
        return finixTransferState
    }
    
    func getFinixCardEntryMode(entryMode: CardInfo.CardEntryMode) -> String {
        
        var cardEntryMode: String
        
        switch entryMode {
            
        case .Keyed:
            cardEntryMode = FinixCardEntryMode.Keyed.rawValue
            
        case .Swiped:
            cardEntryMode = FinixCardEntryMode.Swiped.rawValue
            
        case .ContactlessIcc:
            cardEntryMode = FinixCardEntryMode.ContactlessIcc.rawValue
            
        case .ContactlessMagneticStripe:
            cardEntryMode = FinixCardEntryMode.ContactlessMagneticStripe.rawValue
            
        case .Icc:
            cardEntryMode = FinixCardEntryMode.Icc.rawValue
            
        @unknown default:
            cardEntryMode = FinixCardEntryMode.Other.rawValue
        }
        
        return cardEntryMode
    }
    
    func getFinixCardLogo(logo: CardInfo.CardLogo) -> String {
        
        var cardLogo: String
        
        switch logo {
            
        case .Amex:
            cardLogo = FinixCardLogo.Amex.rawValue
            
        case .CarteBlanche:
            cardLogo = FinixCardLogo.CarteBlanche.rawValue
            
        case .DinersClub:
            cardLogo = FinixCardLogo.DinersClub.rawValue
            
        case .Discover:
            cardLogo = FinixCardLogo.Discover.rawValue
            
        case .JCB:
            cardLogo = FinixCardLogo.JCB.rawValue
            
        case .Mastercard:
            cardLogo = FinixCardLogo.Mastercard.rawValue
            
        case .Visa:
            cardLogo = FinixCardLogo.Visa.rawValue
            
        case .Other:
            cardLogo = FinixCardLogo.Other.rawValue
            
        @unknown default:
            cardLogo = FinixCardLogo.Other.rawValue
        }
        
        return cardLogo
    }
}

struct FinixCaptureResponse: Codable {

    var transferId, traceId: String?
    var transferState, deviceId: String?
    var amount: Double?
    var created, updated: Double?
    var resourceTags: [String: String]?
    
    init(response: CaptureResponse) {
        
        transferId = response.id
        traceId = response.traceId
        transferState = self.getFinixTransferState(state: response.state)
        deviceId = response.deviceId
        amount = Double(truncating: response.amount.decimal as NSNumber)
        created = response.created.timeIntervalSince1970
        updated = response.updated.timeIntervalSince1970
        resourceTags = response.tags
    }
    
    func getFinixTransferState(state: Transfer.State) -> String? {
        
        var finixTransferState: String = ""
        
        switch state {
            
        case .pending:
            finixTransferState = FinixTransferState.pending.rawValue
            
        case .canceled:
            finixTransferState = FinixTransferState.canceled.rawValue
            
        case .failed:
            finixTransferState = FinixTransferState.failed.rawValue
            
        case .succeeded:
            finixTransferState = FinixTransferState.succeeded.rawValue
            
        case .unknown:
            finixTransferState = FinixTransferState.unknown.rawValue
            
        @unknown default:
            finixTransferState = FinixTransferState.unknown.rawValue
        }
        
        return finixTransferState
    }
}
