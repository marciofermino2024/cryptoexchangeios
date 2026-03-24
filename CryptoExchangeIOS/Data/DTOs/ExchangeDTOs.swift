//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct ExchangeMapResponseDTO: Decodable {
    let status: StatusDTO
    let data: [ExchangeMapItemDTO]
}

struct StatusDTO: Decodable {
    let errorCode: Int
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}

struct ExchangeMapItemDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let isActive: Int?
    let firstHistoricalData: String?
    let lastHistoricalData: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case isActive = "is_active"
        case firstHistoricalData = "first_historical_data"
        case lastHistoricalData = "last_historical_data"
    }
}

struct ExchangeInfoResponseDTO: Decodable {
    let status: StatusDTO
    let data: [String: ExchangeInfoDTO]
}

struct ExchangeInfoDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let logo: String?
    let description: String?
    let dateLaunched: String?
    let notice: String?
    let spotVolumeUSD: Double?
    let makerFee: Double?
    let takerFee: Double?
    let weeklyVisits: Int?
    let spot: Int?
    let urls: ExchangeURLsDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case logo
        case description
        case dateLaunched = "date_launched"
        case notice
        case spotVolumeUSD = "spot_volume_usd"
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
        case weeklyVisits = "weekly_visits"
        case spot
        case urls
    }
}

struct ExchangeURLsDTO: Decodable {
    let website: [String]?
    let blog: [String]?
    let chat: [String]?
    let fee: [String]?
    let twitter: [String]?
}

struct ExchangeMarketPairsResponseDTO: Decodable {
    let status: StatusDTO
    let data: ExchangeMarketPairsDataDTO
}

struct ExchangeMarketPairsDataDTO: Decodable {
    let id: Int
    let name: String
    let numMarketPairs: Int?
    let marketPairs: [MarketPairDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case numMarketPairs = "num_market_pairs"
        case marketPairs = "market_pairs"
    }
}

struct MarketPairDTO: Decodable {
    let rankID: Int?
    let marketID: Int?
    let marketPairBase: MarketPairCurrencyDTO?
    let marketPairQuote: MarketPairCurrencyDTO?
    let quote: MarketPairQuoteContainerDTO?

    enum CodingKeys: String, CodingKey {
        case rankID = "rank_id"
        case marketID = "market_id"
        case marketPairBase = "market_pair_base"
        case marketPairQuote = "market_pair_quote"
        case quote
    }
}

struct MarketPairCurrencyDTO: Decodable {
    let currencyID: Int?
    let currencySymbol: String?
    let exchangeSymbol: String?
    let currencyType: String?

    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case currencySymbol = "currency_symbol"
        case exchangeSymbol = "exchange_symbol"
        case currencyType = "currency_type"
    }
}

struct MarketPairQuoteContainerDTO: Decodable {
    let exchangeReported: MarketPairQuoteDTO?
    let usd: MarketPairQuoteDTO?

    enum CodingKeys: String, CodingKey {
        case exchangeReported = "exchange_reported"
        case usd = "USD"
    }
}

struct MarketPairQuoteDTO: Decodable {
    let price: Double?
    let volume24hBase: Double?
    let volume24hQuote: Double?
    let volume24hUSD: Double?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case price
        case volume24hBase = "volume_24h_base"
        case volume24hQuote = "volume_24h_quote"
        case volume24hUSD = "volume_24h"
        case lastUpdated = "last_updated"
    }
}
