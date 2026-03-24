//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct ExchangeListScreen: View {
    @StateObject private var viewModel: ExchangeListViewModel
    private let makeDetailViewModel: (Int) -> ExchangeDetailViewModel

    #if DEBUG
    @State private var showingImageLogs = false
    #endif

    init(
        viewModel: ExchangeListViewModel,
        makeDetailViewModel: @escaping (Int) -> ExchangeDetailViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeDetailViewModel = makeDetailViewModel
    }

    var body: some View {
        content
            .navigationTitle("Exchanges")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingImageLogs = true
                    } label: {
                        Image(systemName: "ladybug")
                    }
                }
                #endif
            }
            .task {
                viewModel.onAppear()
            }
            #if DEBUG
            .sheet(isPresented: $showingImageLogs) {
                DebugImageLogsView()
            }
            #endif
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .empty:
            EmptyStateView()
        case .error(let error):
            ErrorView(error: error) {
                viewModel.retry()
            }
        case .success(let exchanges):
            List {
                ForEach(exchanges) { exchange in
                    NavigationLink {
                        ExchangeDetailScreen(
                            viewModel: makeDetailViewModel(exchange.id)
                        )
                    } label: {
                        ExchangeRowItem(exchange: exchange)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentItem: exchange)
                            }
                    }
                }

                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}
