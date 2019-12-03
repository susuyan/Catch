//
//  MemoryCache.swift
//  SSYCache
//
//  Created by sanmy on 2019/11/21.
//  Copyright © 2019 sanmy. All rights reserved.
//

import Foundation

public enum MemoryStorage {
    
//    var keys = Set<String>()
    
    
    
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
