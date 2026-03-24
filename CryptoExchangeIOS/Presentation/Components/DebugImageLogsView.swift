//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct DebugImageLogsView: View {
    @StateObject private var logger = CMCLogger.shared

    var body: some View {
        NavigationStack {
            List(logger.imageLogs) { entry in
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.url)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text("status: \(entry.statusCode.map(String.init) ?? "-")")
                        Text("latency: \(Int(entry.latencyMs))ms")
                    }
                    .font(.footnote)
                    if let failureReason = entry.failureReason {
                        Text(failureReason)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Image Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
