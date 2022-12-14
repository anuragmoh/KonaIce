//
//  PaymentModel.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import Foundation

struct PaymentModel {
    let username: String
    let password: String
    let application: String
    let version: String
    let deviceID: String
    let merchantID: String
    let serialNumber: String?
    let amount: Double
    let tags: [String: String]
}
