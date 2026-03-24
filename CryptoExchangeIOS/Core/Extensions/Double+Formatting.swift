//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

extension Double {
    func formattedCurrency(maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? String(format: "$%.2f", self)
    }
}
