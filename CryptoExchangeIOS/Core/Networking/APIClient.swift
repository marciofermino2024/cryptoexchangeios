//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

final class APIClient {
    private let session: URLSession
    private let logger: CMCLogger
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, logger: CMCLogger) {
        self.session = session
        self.logger = logger
        self.decoder = JSONDecoder()
    }

    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T {
        let apiKey = AppConfiguration.apiKey
        guard !apiKey.isEmpty else {
            throw AppError.missingAPIKey
        }

        var components = URLComponents(url: AppConfiguration.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw AppError.unknown("Invalid URL for path: \(path)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let requestID = UUID().uuidString.prefix(8)
        await MainActor.run {
            logger.logRequest(id: String(requestID), url: url.absoluteString, apiKey: apiKey)
        }

        let startDate = Date()

        do {
            let (data, response) = try await session.data(for: request)
            let latency = Date().timeIntervalSince(startDate) * 1000

            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    logger.logNetworkError(id: String(requestID), url: url.absoluteString, error: "Invalid HTTP response", statusCode: nil)
                }
                throw AppError.unknown("Invalid response")
            }

            await MainActor.run {
                logger.logResponse(id: String(requestID), statusCode: httpResponse.statusCode, latencyMs: latency, bodySize: data.count)
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                await MainActor.run {
                    logger.logNetworkError(id: String(requestID), url: url.absoluteString, error: "HTTP \(httpResponse.statusCode)", statusCode: httpResponse.statusCode)
                }
                throw AppError.httpError(httpResponse.statusCode)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                let body = String(data: data, encoding: .utf8)
                await MainActor.run {
                    logger.logDecodingError(id: String(requestID), url: url.absoluteString, error: error.localizedDescription, rawBody: body)
                }
                throw AppError.decodingError
            }
        } catch let error as AppError {
            throw error
        } catch let error as URLError {
            if error.code == .timedOut {
                await MainActor.run {
                    logger.logNetworkError(id: String(requestID), url: url.absoluteString, error: error.localizedDescription, statusCode: nil)
                }
                throw AppError.timeout
            }

            await MainActor.run {
                logger.logNetworkError(id: String(requestID), url: url.absoluteString, error: error.localizedDescription, statusCode: nil)
            }
            throw AppError.networkOffline
        } catch {
            await MainActor.run {
                logger.logNetworkError(id: String(requestID), url: url.absoluteString, error: error.localizedDescription, statusCode: nil)
            }
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
