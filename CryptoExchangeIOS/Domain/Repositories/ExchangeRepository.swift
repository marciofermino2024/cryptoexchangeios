//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

protocol ExchangeRepository {
    func fetchExchangeList(start: Int, limit: Int) async throws -> [Exchange]
    func fetchExchangeDetail(id: Int) async throws -> Exchange
    func fetchExchangeMarketPairs(exchangeID: Int, start: Int, limit: Int) async throws -> [ExchangeMarketPair]
}
