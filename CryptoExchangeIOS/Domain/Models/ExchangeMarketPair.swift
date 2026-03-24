//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct ExchangeMarketPair: Identifiable, Hashable {
    let id: String
    let marketPairBase: MarketCurrency
    let marketPairQuote: MarketCurrency
    let priceUSD: Double?
    let volumeUSD24h: Double?
    let lastUpdated: Date?
}

struct MarketCurrency: Hashable {
    let currencyID: Int
    let currencySymbol: String
    let exchangeSymbol: String
    let currencyType: String
}
