//
//  DIContainer.swift
//  App
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//
// DIContainer.swift
import Foundation

public final class DIContainer {
    private struct Provider {
        let make: (DIContainer) -> Any
    }

    private var lock = NSLock()
    private var providers: [ObjectIdentifier: Provider] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]

    public init() {}

    @discardableResult
    public func register<Service>(
        _ type: Service.Type,
        factory: @escaping (DIContainer) -> Service
    ) -> Self {
        let key = ObjectIdentifier(type)
        lock.lock()
        providers[key] = Provider(make: { c in factory(c) })
        singletons.removeValue(forKey: key)
        lock.unlock()
        return self
    }

    public func resolve<Service>(_ type: Service.Type) -> Service {
        let key = ObjectIdentifier(type)

        lock.lock()
        if let cached = singletons[key] as? Service {
            lock.unlock()
            return cached
        }
        guard let provider = providers[key] else {
            lock.unlock()
            fatalError("DIContainer: '\(type)' 미등록")
        }
        lock.unlock()

        let any = provider.make(self)
        guard let instance = any as? Service else {
            fatalError("DIContainer: '\(type)' 캐스팅 실패")
        }

        lock.lock()
        if singletons[key] == nil {
            singletons[key] = instance
        }
        lock.unlock()

        return instance
    }

    public func tryResolve<Service>(_ type: Service.Type) -> Service? {
        let key = ObjectIdentifier(type)

        lock.lock()
        if let cached = singletons[key] as? Service {
            lock.unlock()
            return cached
        }
        let provider = providers[key]
        lock.unlock()

        guard let provider else { return nil }
        let any = provider.make(self)
        guard let instance = any as? Service else { return nil }

        lock.lock()
        if singletons[key] == nil {
            singletons[key] = instance
        }
        lock.unlock()
        return instance
    }

    public func reset() {
        lock.lock()
        providers.removeAll()
        singletons.removeAll()
        lock.unlock()
    }
}
