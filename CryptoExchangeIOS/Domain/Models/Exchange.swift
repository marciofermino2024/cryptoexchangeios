//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct Exchange: Identifiable, Hashable {
    let id: Int
    let name: String
    let slug: String
    let logoURL: String?
    let description: String?
    let websiteURL: String?
    let dateLaunched: Date?
    let spotVolumeUSD: Double?
    let makerFee: Double?
    let takerFee: Double?
    let weeklyVisits: Int?
    let spot: Int?
}
