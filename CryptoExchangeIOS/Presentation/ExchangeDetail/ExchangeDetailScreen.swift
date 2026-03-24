//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct ExchangeDetailScreen: View {
    @StateObject private var viewModel: ExchangeDetailViewModel
    @Environment(\.openURL) private var openURL

    init(viewModel: ExchangeDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.onAppear()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.detailState {
        case .idle, .loading:
            LoadingView()
        case .empty:
            EmptyStateView()
        case .error(let error):
            ErrorView(error: error) {
                viewModel.retry()
            }
        case .success(let exchange):
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    header(exchange)
                    Divider()

                    if let description = exchange.description, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.title3.weight(.semibold))
                            Text(description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                        Divider()
                    }

                    infoCard(exchange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    if let websiteURL = exchange.websiteURL, let url = URL(string: websiteURL) {
                        Button {
                            openURL(url)
                        } label: {
                            Label("Visit Website", systemImage: "safari")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    }

                    Divider()

                    Text("Market Pairs")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    marketPairsSection
                }
                .padding(.bottom, 24)
            }
            .navigationTitle(exchange.name)
        }
    }

    private func header(_ exchange: Exchange) -> some View {
        HStack(spacing: 16) {
            ExchangeLogoView(logoURL: exchange.logoURL, size: 64)
            VStack(alignment: .leading, spacing: 4) {
                Text(exchange.name)
                    .font(.title2.weight(.semibold))
                Text("ID: \(exchange.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
    }

    private func infoCard(_ exchange: Exchange) -> some View {
        VStack(spacing: 0) {
            infoRow(title: "Date Launched", value: exchange.dateLaunched?.formattedMediumDate() ?? "N/A")
            Divider().padding(.leading, 16)
            infoRow(title: "Spot Volume (USD)", value: exchange.spotVolumeUSD?.formattedCurrency(maximumFractionDigits: 2) ?? "N/A")
            Divider().padding(.leading, 16)
            infoRow(title: "Maker Fee", value: exchange.makerFee.map { String(format: "%.4f%%", $0) } ?? "N/A")
            Divider().padding(.leading, 16)
            infoRow(title: "Taker Fee", value: exchange.takerFee.map { String(format: "%.4f%%", $0) } ?? "N/A")
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
        .padding(16)
    }

    @ViewBuilder
    private var marketPairsSection: some View {
        switch viewModel.pairsState {
        case .idle, .loading:
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding(16)
        case .empty:
            Text("No market pairs available.")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
        case .error(let error):
            VStack(alignment: .leading, spacing: 8) {
                Text(error.userFriendlyMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                Button("Try Again") {
                    viewModel.retry()
                }
            }
            .padding(16)
        case .success(let pairs):
            LazyVStack(spacing: 0) {
                ForEach(pairs) { pair in
                    MarketPairRowItem(pair: pair)
                        .padding(.horizontal, 16)
                        .onAppear {
                            viewModel.loadMorePairsIfNeeded(currentItem: pair)
                        }
                    Divider().padding(.leading, 16)
                }

                if viewModel.isLoadingMorePairs {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
    }
}
