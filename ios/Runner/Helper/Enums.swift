//
//  Enums.swift
//  Runner
//
//  Created by Tushar Jadhav on 03/05/22.
//

import Foundation

/// encodes the type of card entry
public enum FinixCardEntryMode {

    /// Manually keyed in
    case Keyed

    /// Swiped with magstripe
    case Swiped

    /// Near field magstripe read
    case ContactlessMagneticStripe

    /// Integrated Circuit Card read
    case Icc

    /// Integrated Circuit Card contactless read (i.e. tap)
    case ContactlessIcc
}

/// encodes the card logo. Unknown values are `Other`
public enum FinixCardLogo {

    /// Visa
    case Visa

    /// Mastercard
    case Mastercard

    /// Discover
    case Discover

    /// American Express
    case Amex

    /// Diners Club
    case DinersClub

    /// JCB
    case JCB

    /// Carte Blanche
    case CarteBlanche

    /// Other card brand
    case Other
}
