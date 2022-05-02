//
//  SaleReceipt.swift
//  Runner
//
//  Created by Tushar Jadhav on 02/05/22.
//

import Foundation

struct SaleResponseReceipt: Codable {
    
    let merchantName, merchantAddress, date, applicationLabel, applicationIdentifier, merchantId, referenceNumber, accountNumber, cardBrand, entryMode, transactionId, approvalCode, responseCode, responseMessage, cryptogram, transactionType: String?

    enum CodingKeys: String, CodingKey {
        
        case merchantName
        case merchantAddress
        case date
        case applicationLabel
        case applicationIdentifier
        case merchantId
        case referenceNumber
        case accountNumber
        case cardBrand
        case entryMode
        case transactionId
        case approvalCode
        case responseCode
        case responseMessage
        case cryptogram
        case transactionType
    }
}
