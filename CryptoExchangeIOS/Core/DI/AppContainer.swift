//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//


import Foundation

final class AppContainer: ObservableObject {
    let logger: CMCLogger
    let apiClient: APIClient
    let exchangeService: ExchangeServiceProtocol
    let exchangeRepository: ExchangeRepository
    let getExchangeListUseCase: GetExchangeListUseCase
    let getExchangeDetailUseCase: GetExchangeDetailUseCase
    let getExchangeMarketPairsUseCase: GetExchangeMarketPairsUseCase

    init(
        logger: CMCLogger,
        apiClient: APIClient,
        exchangeService: ExchangeServiceProtocol,
        exchangeRepository: ExchangeRepository,
        getExchangeListUseCase: GetExchangeListUseCase,
        getExchangeDetailUseCase: GetExchangeDetailUseCase,
        getExchangeMarketPairsUseCase: GetExchangeMarketPairsUseCase
    ) {
        self.logger = logger
        self.apiClient = apiClient
        self.exchangeService = exchangeService
        self.exchangeRepository = exchangeRepository
        self.getExchangeListUseCase = getExchangeListUseCase
        self.getExchangeDetailUseCase = getExchangeDetailUseCase
        self.getExchangeMarketPairsUseCase = getExchangeMarketPairsUseCase
    }

    static func makeDefault() -> AppContainer {
        let logger = CMCLogger.shared
        let apiClient = APIClient(logger: logger)
        let service = ExchangeService(apiClient: apiClient)
        let repository = ExchangeRepositoryImpl(service: service, logger: logger)

        return AppContainer(
            logger: logger,
            apiClient: apiClient,
            exchangeService: service,
            exchangeRepository: repository,
            getExchangeListUseCase: GetExchangeListUseCase(repository: repository),
            getExchangeDetailUseCase: GetExchangeDetailUseCase(repository: repository),
            getExchangeMarketPairsUseCase: GetExchangeMarketPairsUseCase(repository: repository)
        )
    }
}
