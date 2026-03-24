//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct DebugErrorView: View {
    @StateObject private var logger = CMCLogger.shared

    var body: some View {
        List {
            if let context = logger.lastErrorContext {
                Section("API Debug") {
                    LabeledContent("Request ID", value: context.requestID)
                    LabeledContent("URL", value: context.url)
                    LabeledContent("Status", value: context.statusCode.map(String.init) ?? "-")
                    LabeledContent("Error", value: context.error ?? "-")
                    if let snippet = context.jsonSnippet {
                        Text(snippet)
                            .font(.footnote.monospaced())
                            .textSelection(.enabled)
                    }
                }
            } else {
                Text("No debug context available.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Error Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
