//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct GetExchangeDetailUseCase {
    private let repository: ExchangeRepository

    init(repository: ExchangeRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> Exchange {
        try await repository.fetchExchangeDetail(id: id)
    }
}
