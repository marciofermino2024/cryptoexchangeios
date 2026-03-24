//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct GetExchangeMarketPairsUseCase {
    private let repository: ExchangeRepository

    init(repository: ExchangeRepository) {
        self.repository = repository
    }

    func callAsFunction(exchangeID: Int, start: Int, limit: Int) async throws -> [ExchangeMarketPair] {
        try await repository.fetchExchangeMarketPairs(exchangeID: exchangeID, start: start, limit: limit)
    }
}
