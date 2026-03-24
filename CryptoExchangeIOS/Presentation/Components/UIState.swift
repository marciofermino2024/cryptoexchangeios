//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import Foundation

enum UIState<T> {
    case idle
    case loading
    case success(T)
    case empty
    case error(AppError)
}
