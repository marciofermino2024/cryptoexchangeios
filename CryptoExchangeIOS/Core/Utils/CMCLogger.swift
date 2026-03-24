//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

struct ImageLogEntry: Identifiable {
    let id = UUID()
    let url: String
    let statusCode: Int?
    let latencyMs: Double
    let bytes: Int?
    let mimeType: String?
    let cacheHit: Bool
    let failureReason: String?
    let timestamp: Date = Date()
}

struct RequestLog {
    let requestID: String
    let url: String
    let statusCode: Int?
    let latencyMs: Double?
    let bodySizeBytes: Int?
    let error: String?
    let jsonSnippet: String?
    let decodingPath: String?
}

@MainActor
final class CMCLogger: ObservableObject {
    static let shared = CMCLogger()

    @Published private(set) var imageLogs: [ImageLogEntry] = []
    @Published private(set) var lastErrorContext: RequestLog?

    private init() {}

    func logRequest(id: String, url: String, apiKey: String) {
        #if DEBUG
        print("[CMC] ▶ id=\(id) url=\(url) key=***\(mask(apiKey: apiKey))")
        #endif
    }

    func logResponse(id: String, statusCode: Int, latencyMs: Double, bodySize: Int) {
        #if DEBUG
        print("[CMC] ◀ id=\(id) status=\(statusCode) \(String(format: "%.0f", latencyMs))ms \(bodySize)B")
        #endif
    }

    func logDecodingError(id: String, url: String, error: String, rawBody: String?) {
        lastErrorContext = RequestLog(
            requestID: id,
            url: url,
            statusCode: nil,
            latencyMs: nil,
            bodySizeBytes: rawBody?.count,
            error: error,
            jsonSnippet: rawBody,
            decodingPath: error
        )
        #if DEBUG
        print("[CMC] decode error: \(error)")
        #endif
    }

    func logNetworkError(id: String, url: String, error: String, statusCode: Int?) {
        lastErrorContext = RequestLog(
            requestID: id,
            url: url,
            statusCode: statusCode,
            latencyMs: nil,
            bodySizeBytes: nil,
            error: error,
            jsonSnippet: nil,
            decodingPath: nil
        )
        #if DEBUG
        print("[CMC] network error: \(error)")
        #endif
    }

    func logLogoURL(exchangeID: Int, name: String, logoURL: String?) {
        #if DEBUG
        if let logoURL, !logoURL.isEmpty {
            print("[IMG] exchange id=\(exchangeID) name=\(name) logoURL=\(logoURL)")
        } else {
            print("[IMG] missing logo id=\(exchangeID) name=\(name)")
        }
        #endif
    }

    func logImageResult(url: String, statusCode: Int?, latencyMs: Double, bytes: Int?, mimeType: String?, cacheHit: Bool, failureReason: String?) {
        let entry = ImageLogEntry(
            url: url,
            statusCode: statusCode,
            latencyMs: latencyMs,
            bytes: bytes,
            mimeType: mimeType,
            cacheHit: cacheHit,
            failureReason: failureReason
        )

        imageLogs.insert(entry, at: 0)
        if imageLogs.count > 20 {
            imageLogs = Array(imageLogs.prefix(20))
        }

        #if DEBUG
        print("[IMG] \(url) status=\(statusCode.map(String.init) ?? "-")")
        #endif
    }

    private func mask(apiKey: String) -> String {
        String(apiKey.suffix(4))
    }
}
