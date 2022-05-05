//
//  Enums.swift
//  Runner
//
//  Created by Tushar Jadhav on 03/05/22.
//

import Foundation

/// encodes the type of card entry
public enum FinixCardEntryMode: String {

    /// Manually keyed in
    case Keyed = "Keyed"

    /// Swiped with magstripe
    case Swiped = "Swiped"

    /// Near field magstripe read
    case ContactlessMagneticStripe = "ContactlessMagneticStripe"

    /// Integrated Circuit Card read
    case Icc = "Icc"

    /// Integrated Circuit Card contactless read (i.e. tap)
    case ContactlessIcc = "ContactlessIcc"
    
    case Other = "Other"
}

/// encodes the card logo. Unknown values are `Other`
public enum FinixCardLogo: String {

    /// Visa
    case Visa = "Visa"

    /// Mastercard
    case Mastercard = "Mastercard"

    /// Discover
    case Discover = "Discover"

    /// American Express
    case Amex = "Amex"

    /// Diners Club
    case DinersClub = "DinersClub"

    /// JCB
    case JCB = "JCB"

    /// Carte Blanche
    case CarteBlanche = "CarteBlanche"

    /// Other card brand
    case Other = "Other"
}

public enum FinixTransferState: String {

    case pending = "pending"

    case failed = "failed"

    case succeeded = "succeeded"

    case canceled = "canceled"

    case unknown = "unknown"
}

public enum FinixDisplayText: String {

    case insertTapSwipeCard = "Insert, Swipe or Tap Card"
    case removeCard = "Card removed"
    case processing = "Processing"
}

public enum TransactionAnimationName: String {
    
    case insertSwipeTapCard = "insertCard"
    case removeCard = "removeCard"
    case progress = "progress"
}

