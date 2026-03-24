//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

enum ExchangeMapper {
    static func map(_ dto: ExchangeInfoDTO) -> Exchange {
        Exchange(
            id: dto.id,
            name: dto.name,
            slug: dto.slug,
            logoURL: dto.logo,
            description: dto.description,
            websiteURL: dto.urls?.website?.first,
            dateLaunched: parseDate(dto.dateLaunched),
            spotVolumeUSD: dto.spotVolumeUSD,
            makerFee: dto.makerFee,
            takerFee: dto.takerFee,
            weeklyVisits: dto.weeklyVisits,
            spot: dto.spot
        )
    }

    static func parseDate(_ value: String?) -> Date? {
        guard let value, !value.isEmpty else { return nil }

        let formatters = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd"
        ].map { format -> DateFormatter in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = format
            return formatter
        }

        for formatter in formatters {
            if let date = formatter.date(from: value) {
                return date
            }
        }

        return nil
    }
}

enum MarketPairMapper {
    static func map(_ dto: MarketPairDTO, index: Int) -> ExchangeMarketPair? {
        guard
            let base = dto.marketPairBase,
            let quote = dto.marketPairQuote,
            let baseCurrencyID = base.currencyID,
            let baseCurrencySymbol = base.currencySymbol,
            let baseExchangeSymbol = base.exchangeSymbol,
            let baseCurrencyType = base.currencyType,
            let quoteCurrencyID = quote.currencyID,
            let quoteCurrencySymbol = quote.currencySymbol,
            let quoteExchangeSymbol = quote.exchangeSymbol,
            let quoteCurrencyType = quote.currencyType
        else {
            return nil
        }

        let price = dto.quote?.usd?.price ?? dto.quote?.exchangeReported?.price
        let volume = dto.quote?.usd?.volume24hUSD
        let id = dto.marketID.map(String.init) ?? String(index)

        return ExchangeMarketPair(
            id: id,
            marketPairBase: MarketCurrency(
                currencyID: baseCurrencyID,
                currencySymbol: baseCurrencySymbol,
                exchangeSymbol: baseExchangeSymbol,
                currencyType: baseCurrencyType
            ),
            marketPairQuote: MarketCurrency(
                currencyID: quoteCurrencyID,
                currencySymbol: quoteCurrencySymbol,
                exchangeSymbol: quoteExchangeSymbol,
                currencyType: quoteCurrencyType
            ),
            priceUSD: price,
            volumeUSD24h: volume,
            lastUpdated: nil
        )
    }
}
