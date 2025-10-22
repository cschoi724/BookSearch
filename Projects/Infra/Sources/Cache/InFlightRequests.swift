//
//  InFlightRequests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

// 동시에 같은 URL을 요청할 때, 첫 요청만 수행하고 나머지는 결과를 공유하기 위한 대기열
actor InFlightRequests {
    private var waiters: [URL: [CheckedContinuation<Data, Error>]] = [:]

    // 리더가될 수 있으면 true를, 이미 진행 중이면 false를 반환
    func begin(_ url: URL) -> Bool {
        if waiters[url] != nil { return false }
        waiters[url] = []
        return true
    }

    // 진행 중인 요청의 결과를 기다림 (이미 begin 된 상태여야함)
    func wait(_ url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Data, Error>) in
            waiters[url, default: []].append(cont)
        }
    }

    // 완료 시 모든 대기자에게 결과 전달 후 정리
    func finish(_ url: URL, result: Result<Data, Error>) {
        let continuations = waiters[url] ?? []
        waiters[url] = nil
        for c in continuations {
            switch result {
            case .success(let data): c.resume(returning: data)
            case .failure(let error): c.resume(throwing: error)
            }
        }
    }
}
