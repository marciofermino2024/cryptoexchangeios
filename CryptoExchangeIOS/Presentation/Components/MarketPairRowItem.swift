//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct MarketPairRowItem: View {
    let pair: ExchangeMarketPair

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(pair.marketPairBase.currencySymbol)/\(pair.marketPairQuote.currencySymbol)")
                    .font(.headline)
                Text("Vol 24h: \(formatVolume(pair.volumeUSD24h))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(formatPrice(pair.priceUSD))
                    .font(.headline)
                    .foregroundStyle(.tint)
                Text("Price (USD)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    private func formatPrice(_ price: Double?) -> String {
        guard let price else { return "N/A" }
        if price >= 1 {
            return String(format: "$%.2f", price)
        }
        return String(format: "$%.6f", price)
    }

    private func formatVolume(_ volume: Double?) -> String {
        guard let volume else { return "N/A" }
        return String(format: "$%.2fM", volume / 1_000_000)
    }
}
