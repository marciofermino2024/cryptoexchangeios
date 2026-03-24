//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct ExchangeLogoView: View {
    let logoURL: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: size, height: size)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .onAppear {
                                Task { @MainActor in
                                    CMCLogger.shared.logImageResult(url: logoURL, statusCode: 200, latencyMs: 0, bytes: nil, mimeType: nil, cacheHit: false, failureReason: nil)
                                }
                            }
                    case .failure:
                        placeholderView
                            .onAppear {
                                Task { @MainActor in
                                    CMCLogger.shared.logImageResult(url: logoURL, statusCode: nil, latencyMs: 0, bytes: nil, mimeType: nil, cacheHit: false, failureReason: "AsyncImage failed")
                                }
                            }
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: size * 0.167, style: .continuous))
    }

    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.167, style: .continuous)
                .fill(Color(.secondarySystemBackground))
            Text("EX")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
