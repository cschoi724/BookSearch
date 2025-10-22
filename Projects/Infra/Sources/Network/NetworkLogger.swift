//
//  NetworkLogger.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol NetworkLogger {
    func willSend(_ request: URLRequest)
    func didReceive(_ data: Data, response: HTTPURLResponse)
    func didFail(_ error: Error, response: HTTPURLResponse?)
}

public struct ConsoleNetworkLogger: NetworkLogger {
    public init() {}

    public func willSend(_ request: URLRequest) {
        #if DEBUG
        print("➡️ [REQ]", request.httpMethod ?? "", request.url?.absoluteString ?? "")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
          print("   headers:", headers)
        }
        if let body = request.httpBody, let s = String(data: body, encoding: .utf8) {
          print("   body:", s)
        }
        #endif
    }

    public func didReceive(_ data: Data, response: HTTPURLResponse) {
        #if DEBUG
        print("⬅️ [RES]", response.statusCode, response.url?.absoluteString ?? "")
        if let s = String(data: data, encoding: .utf8) {
          print("   body:", s.prefix(500))
        }
        #endif
    }

    public func didFail(_ error: Error, response: HTTPURLResponse?) {
        #if DEBUG
        print("❌ [ERR]", response?.statusCode ?? -1, response?.url?.absoluteString ?? "", error)
        #endif
    }
}
