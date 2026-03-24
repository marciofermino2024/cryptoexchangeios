//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct ExchangeRowItem: View {
    let exchange: Exchange

    var body: some View {
        HStack(spacing: 12) {
            ExchangeLogoView(logoURL: exchange.logoURL, size: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(exchange.name)
                    .font(.headline)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption)
                        .foregroundStyle(.tint)
                    Text(Self.formatVolume(exchange.spotVolumeUSD))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(Self.formatDate(exchange))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }

    static func formatVolume(_ volume: Double?) -> String {
        guard let volume else { return "N/A" }
        let billions = volume / 1_000_000_000
        if billions >= 1 {
            return String(format: "$%.2fB", billions)
        }
        let millions = volume / 1_000_000
        if millions >= 1 {
            return String(format: "$%.2fM", millions)
        }
        return String(format: "$%.0f", volume)
    }

    static func formatDate(_ exchange: Exchange) -> String {
        exchange.dateLaunched?.formattedMediumDate() ?? "N/A"
    }
}
