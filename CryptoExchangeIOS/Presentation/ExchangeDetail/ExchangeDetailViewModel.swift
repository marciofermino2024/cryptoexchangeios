//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

@MainActor
final class ExchangeDetailViewModel: ObservableObject {
    @Published private(set) var detailState: UIState<Exchange> = .idle
    @Published private(set) var pairsState: UIState<[ExchangeMarketPair]> = .idle
    @Published private(set) var isLoadingMorePairs = false

    private let exchangeID: Int
    private let getExchangeDetailUseCase: GetExchangeDetailUseCase
    private let getExchangeMarketPairsUseCase: GetExchangeMarketPairsUseCase

    private let pairsPageSize = 20
    private var currentPairsPage = 1
    private var hasMorePairs = true
    private var allPairs: [ExchangeMarketPair] = []

    init(
        exchangeID: Int,
        getExchangeDetailUseCase: GetExchangeDetailUseCase,
        getExchangeMarketPairsUseCase: GetExchangeMarketPairsUseCase
    ) {
        self.exchangeID = exchangeID
        self.getExchangeDetailUseCase = getExchangeDetailUseCase
        self.getExchangeMarketPairsUseCase = getExchangeMarketPairsUseCase
    }

    func onAppear() {
        guard case .idle = detailState else { return }
        load()
    }

    func load() {
        detailState = .loading
        pairsState = .loading
        allPairs.removeAll()
        currentPairsPage = 1
        hasMorePairs = true

        Task {
            await fetchDetail()
            await fetchPairs(start: 1)
        }
    }

    func retry() {
        load()
    }

    func loadMorePairsIfNeeded(currentItem: ExchangeMarketPair) {
        guard hasMorePairs, !isLoadingMorePairs else { return }
        guard case .success(let items) = pairsState else { return }
        let thresholdIndex = max(items.count - 3, 0)
        guard let currentIndex = items.firstIndex(where: { $0.id == currentItem.id }) else { return }
        guard currentIndex >= thresholdIndex else { return }

        isLoadingMorePairs = true
        currentPairsPage += 1

        Task {
            await fetchPairs(start: (currentPairsPage - 1) * pairsPageSize + 1)
        }
    }

    private func fetchDetail() async {
        do {
            let exchange = try await getExchangeDetailUseCase(id: exchangeID)
            detailState = .success(exchange)
        } catch let error as AppError {
            detailState = .error(error)
        } catch {
            detailState = .error(.unknown(error.localizedDescription))
        }
    }

    private func fetchPairs(start: Int) async {
        do {
            let result = try await getExchangeMarketPairsUseCase(exchangeID: exchangeID, start: start, limit: pairsPageSize)
            if result.isEmpty {
                hasMorePairs = false
                if allPairs.isEmpty {
                    pairsState = .empty
                }
            } else {
                allPairs.append(contentsOf: result)
                hasMorePairs = result.count == pairsPageSize
                pairsState = .success(allPairs)
            }
        } catch let error as AppError {
            if allPairs.isEmpty {
                pairsState = .error(error)
            }
        } catch {
            if allPairs.isEmpty {
                pairsState = .error(.unknown(error.localizedDescription))
            }
        }

        isLoadingMorePairs = false
    }
}
