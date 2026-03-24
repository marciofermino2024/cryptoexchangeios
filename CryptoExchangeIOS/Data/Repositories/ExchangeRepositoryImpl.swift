//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

final class ExchangeRepositoryImpl: ExchangeRepository {
    private let service: ExchangeServiceProtocol
    private let logger: CMCLogger

    private var listCache: [String: [Exchange]] = [:]
    private var detailCache: [Int: Exchange] = [:]

    init(service: ExchangeServiceProtocol, logger: CMCLogger) {
        self.service = service
        self.logger = logger
    }

    func fetchExchangeList(start: Int, limit: Int) async throws -> [Exchange] {
        let cacheKey = "list_\(start)_\(limit)"
        if let cached = listCache[cacheKey] {
            return cached
        }

        let mapResponse = try await service.getExchangeMap(start: start, limit: limit)
        let ids = mapResponse.data.map(\.id)
        if ids.isEmpty {
            return []
        }

        let infoResponse = try await service.getExchangeInfo(ids: ids.map(String.init).joined(separator: ","))
        let infoByID = infoResponse.data
        let orderMap = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($1, $0) })

        let exchanges = infoByID.values
            .map { dto in
                Task { @MainActor in
                    logger.logLogoURL(exchangeID: dto.id, name: dto.name, logoURL: dto.logo)
                }
                return ExchangeMapper.map(dto)
            }
            .sorted { lhs, rhs in
                (orderMap[lhs.id] ?? .max) < (orderMap[rhs.id] ?? .max)
            }

        listCache[cacheKey] = exchanges
        return exchanges
    }

    func fetchExchangeDetail(id: Int) async throws -> Exchange {
        if let cached = detailCache[id] {
            return cached
        }

        let response = try await service.getExchangeInfo(ids: String(id))
        guard let dto = response.data.values.first else {
            throw AppError.unknown("Exchange \(id) not found in response")
        }

        await MainActor.run {
            logger.logLogoURL(exchangeID: dto.id, name: dto.name, logoURL: dto.logo)
        }

        let exchange = ExchangeMapper.map(dto)
        detailCache[id] = exchange
        return exchange
    }

    func fetchExchangeMarketPairs(exchangeID: Int, start: Int, limit: Int) async throws -> [ExchangeMarketPair] {
        let response = try await service.getExchangeMarketPairs(id: exchangeID, start: start, limit: limit)
        return (response.data.marketPairs ?? []).enumerated().compactMap { index, dto in
            MarketPairMapper.map(dto, index: index)
        }
    }
}
