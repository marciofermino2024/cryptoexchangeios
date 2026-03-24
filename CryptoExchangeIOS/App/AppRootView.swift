//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//


import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var container: AppContainer

    var body: some View {
        NavigationStack {
            ExchangeListScreen(
                viewModel: ExchangeListViewModel(
                    getExchangeListUseCase: container.getExchangeListUseCase
                ),
                makeDetailViewModel: { exchangeID in
                    ExchangeDetailViewModel(
                        exchangeID: exchangeID,
                        getExchangeDetailUseCase: container.getExchangeDetailUseCase,
                        getExchangeMarketPairsUseCase: container.getExchangeMarketPairsUseCase
                    )
                }
            )
        }
        .tint(.primary)
    }
}
