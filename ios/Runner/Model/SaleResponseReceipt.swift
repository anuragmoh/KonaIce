//
//  SaleResponseReceipt.swift
//  Runner
//
//  Created by Tushar Jadhav on 02/05/22.
//

import Foundation
import FinixPOS

struct SaleResponseReceipt: Codable {
    
    let merchantName, merchantAddress, date, applicationLabel, applicationIdentifier, merchantId, referenceNumber, accountNumber, cardBrand, entryMode, transactionId, approvalCode, responseCode, responseMessage, cryptogram, transactionType: String?
    
    let transferId, traceId, transferState : String?
    let amount: Decimal?
    let created, updated: Date?
    let resourceTags: [String: String]?
    
    /// the entry mode
   let entryMode: FinixCardEntryMode?

    /// the masked account number
    let maskedAccountNumber: String?

    /// the card logo, e.g.
    let cardLogo: FinixCardLogo?

    /// the card holder's name
    let cardHolderName: String?

    /// the expiry month
    let expirationMonth: String?

    /// the expiry year
    let expirationYear: String?

    /// AID from a Magstripe-Mode contactless transaction
    let applicationIdentifier: String?
    
    let responseSuccess, responsePending: Bool?
}
