//
//  MemoryCache.swift
//  SSYCache
//
//  Created by sanmy on 2019/11/21.
//  Copyright © 2019 sanmy. All rights reserved.
//

import Foundation

public enum MemoryStorage {
        
    public class Backend<T: CacheCostCalculable> {
        
        let storage = NSCache<NSString, StorageObject<T>>()
        
        var keys = Set<String>()

        private var cleanTimer: Timer? = nil
        private let lock = NSLock()
        
        public var config: Config {
            didSet {
                storage.totalCostLimit = config.totalCostLimit
                storage.countLimit = config.countLimit
            }
        }
        
        public init(config: Config) {
            self.config = config
            storage.totalCostLimit = config.totalCostLimit
            storage.countLimit = config.countLimit

            cleanTimer = .scheduledTimer(withTimeInterval: config.cleanInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.removeExpired()
            }
        }
        
        func removeExpired() {
            lock.lock()
            defer { lock.unlock() }
            for key in keys {
                let nsKey = key as NSString
                guard let object = storage.object(forKey: nsKey) else {
                    // This could happen if the object is moved by cache `totalCostLimit` or `countLimit` rule.
                    // We didn't remove the key yet until now, since we do not want to introduce additonal lock.
                    // See https://github.com/onevcat/Kingfisher/issues/1233
                    keys.remove(key)
                    continue
                }
                if object.estimatedExpiration.isPast {
                    storage.removeObject(forKey: nsKey)
                    keys.remove(key)
                }
            }
        }
        
        func store(
            value: T,
            forKey key: String) throws
        {
            setoreNoThrow(value: value, forKey: key, expiration: nil)
        }
        
        func store(
            value: T,
            forKey key: String,
            expiration: StorageExpiration? = nil) throws
        {
            setoreNoThrow(value: value, forKey: key, expiration: expiration)
        }
        
        func setoreNoThrow(
            value: T,
            forKey key: String,
            expiration: StorageExpiration? = nil)
        {
            lock.lock()
            defer { lock.unlock() }
            let expiration = expiration ?? config.expiration
            // The expiration indicates that already expired, no need to store.
            guard !expiration.isExpired else { return }
            
            let object = StorageObject(value, key: key, expiration: expiration)
            storage.setObject(object, forKey: key as NSString, cost: value.cacheCost)
            keys.insert(key)
        }
        
        func value(forKey key: String, extendingExpiration: ExpirationExtending = .cacheTime) -> T? {
            guard let object = storage.object(forKey: key as NSString) else {
                return nil
            }
            if object.expired {
                return nil
            }
            object.extendExpiration(extendingExpiration)
            return object.value
        }

        func isCached(forKey key: String) -> Bool {
            guard let _ = value(forKey: key, extendingExpiration: .none) else {
                return false
            }
            return true
        }

        func remove(forKey key: String) throws {
            lock.lock()
            defer { lock.unlock() }
            storage.removeObject(forKey: key as NSString)
            keys.remove(key)
        }

        func removeAll() throws {
            lock.lock()
            defer { lock.unlock() }
            storage.removeAllObjects()
            keys.removeAll()
        }
        
    }
    
}


extension MemoryStorage {
    /// Represents the config used in a `MemoryStorage`.
    public struct Config {

        /// Total cost limit of the storage in bytes.
        public var totalCostLimit: Int

        /// The item count limit of the memory storage.
        public var countLimit: Int = .max

        /// The `StorageExpiration` used in this memory storage. Default is `.seconds(300)`,
        /// means that the memory cache would expire in 5 minutes.
        public var expiration: StorageExpiration = .seconds(300)

        /// The time interval between the storage do clean work for swiping expired items.
        public let cleanInterval: TimeInterval

        /// Creates a config from a given `totalCostLimit` value.
        ///
        /// - Parameters:
        ///   - totalCostLimit: Total cost limit of the storage in bytes.
        ///   - cleanInterval: The time interval between the storage do clean work for swiping expired items.
        ///                    Default is 120, means the auto eviction happens once per two minutes.
        ///
        /// - Note:
        /// Other members of `MemoryStorage.Config` will use their default values when created.
        public init(totalCostLimit: Int, cleanInterval: TimeInterval = 120) {
            self.totalCostLimit = totalCostLimit
            self.cleanInterval = cleanInterval
        }
    }
}


extension MemoryStorage {
    class StorageObject<T> {
        let value: T
        let expiration: StorageExpiration
        let key: String
        
        private(set) var estimatedExpiration: Date
        
        init(_ value: T, key: String, expiration: StorageExpiration) {
            self.value = value
            self.key = key
            self.expiration = expiration
            
            self.estimatedExpiration = expiration.estimatedExpirationSinceNow
        }

        func extendExpiration(_ extendingExpiration: ExpirationExtending = .cacheTime) {
            switch extendingExpiration {
            case .none:
                return
            case .cacheTime:
                self.estimatedExpiration = expiration.estimatedExpirationSinceNow
            case .expirationTime(let expirationTime):
                self.estimatedExpiration = expirationTime.estimatedExpirationSinceNow
            }
        }
        
        var expired: Bool {
            return estimatedExpiration.isPast
        }
    }
}
