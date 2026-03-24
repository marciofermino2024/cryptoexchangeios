//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case missingAPIKey
    case networkOffline
    case timeout
    case httpError(Int)
    case decodingError
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "CMC_API_KEY is not configured. Please configure it before making API calls."
        case .networkOffline:
            return "No internet connection. Check your connection and try again."
        case .timeout:
            return "Request timed out. Please try again."
        case .httpError(let statusCode):
            return "Server returned error \(statusCode). Please try again later."
        case .decodingError:
            return "Failed to parse server response."
        case .unknown(let detail):
            return detail
        }
    }

    var userFriendlyMessage: String {
        errorDescription ?? "Unexpected error"
    }
}
