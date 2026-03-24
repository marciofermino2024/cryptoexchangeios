//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct GetExchangeListUseCase {
    private let repository: ExchangeRepository

    init(repository: ExchangeRepository) {
        self.repository = repository
    }

    func callAsFunction(start: Int, limit: Int) async throws -> [Exchange] {
        try await repository.fetchExchangeList(start: start, limit: limit)
    }
}
