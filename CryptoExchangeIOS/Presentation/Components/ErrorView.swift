//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct ErrorView: View {
    let error: AppError
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Something went wrong")
                .font(.title3.weight(.semibold))
            Text(error.userFriendlyMessage)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)

            #if DEBUG
            NavigationLink("Error Details") {
                DebugErrorView()
            }
            .buttonStyle(.bordered)
            #endif
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
