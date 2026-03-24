//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("No Exchanges")
                .font(.title3.weight(.semibold))
            Text("There are no exchanges to display at this time.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
