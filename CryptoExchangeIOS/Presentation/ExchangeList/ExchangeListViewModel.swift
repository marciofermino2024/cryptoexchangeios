//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

@MainActor
final class ExchangeListViewModel: ObservableObject {
    @Published private(set) var state: UIState<[Exchange]> = .idle
    @Published private(set) var isLoadingMore = false

    private let getExchangeListUseCase: GetExchangeListUseCase
    private let pageSize = 20
    private var currentPage = 1
    private var hasMore = true
    private var allExchanges: [Exchange] = []
    private var loadingTask: Task<Void, Never>?

    init(getExchangeListUseCase: GetExchangeListUseCase) {
        self.getExchangeListUseCase = getExchangeListUseCase
    }

    func onAppear() {
        guard case .idle = state else { return }
        loadInitial()
    }

    func loadInitial() {
        loadingTask?.cancel()
        currentPage = 1
        hasMore = true
        allExchanges.removeAll()
        state = .loading

        loadingTask = Task {
            await fetchPage(start: 1)
        }
    }

    func retry() {
        loadInitial()
    }

    func refresh() async {
        currentPage = 1
        hasMore = true
        allExchanges.removeAll()
        state = .loading
        await fetchPage(start: 1)
    }

    func loadMoreIfNeeded(currentItem: Exchange) {
        guard hasMore, !isLoadingMore else { return }
        guard case .success(let items) = state else { return }
        let thresholdIndex = max(items.count - 3, 0)
        guard let currentIndex = items.firstIndex(where: { $0.id == currentItem.id }) else { return }
        guard currentIndex >= thresholdIndex else { return }

        isLoadingMore = true
        currentPage += 1

        loadingTask = Task {
            await fetchPage(start: (currentPage - 1) * pageSize + 1)
        }
    }

    private func fetchPage(start: Int) async {
        do {
            let result = try await getExchangeListUseCase(start: start, limit: pageSize)
            if result.isEmpty {
                hasMore = false
                if allExchanges.isEmpty {
                    state = .empty
                }
            } else {
                allExchanges.append(contentsOf: result)
                hasMore = result.count == pageSize
                state = .success(allExchanges)
            }
        } catch let error as AppError {
            if allExchanges.isEmpty {
                state = .error(error)
            }
        } catch {
            if allExchanges.isEmpty {
                state = .error(.unknown(error.localizedDescription))
            }
        }

        isLoadingMore = false
    }
}
