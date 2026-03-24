//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

protocol ExchangeServiceProtocol {
    func getExchangeMap(start: Int, limit: Int) async throws -> ExchangeMapResponseDTO
    func getExchangeInfo(ids: String) async throws -> ExchangeInfoResponseDTO
    func getExchangeMarketPairs(id: Int, start: Int, limit: Int) async throws -> ExchangeMarketPairsResponseDTO
}

final class ExchangeService: ExchangeServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getExchangeMap(start: Int, limit: Int) async throws -> ExchangeMapResponseDTO {
        try await apiClient.get(
            path: "v1/exchange/map",
            queryItems: [
                URLQueryItem(name: "start", value: String(start)),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "sort", value: "volume_24h")
            ]
        )
    }

    func getExchangeInfo(ids: String) async throws -> ExchangeInfoResponseDTO {
        try await apiClient.get(
            path: "v1/exchange/info",
            queryItems: [
                URLQueryItem(name: "id", value: ids)
            ]
        )
    }

    func getExchangeMarketPairs(id: Int, start: Int, limit: Int) async throws -> ExchangeMarketPairsResponseDTO {
        try await apiClient.get(
            path: "v1/exchange/market-pairs/latest",
            queryItems: [
                URLQueryItem(name: "id", value: String(id)),
                URLQueryItem(name: "start", value: String(start)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }
}
