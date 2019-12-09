//
//  Cache.swift
//  SSYCache
//
//  Created by sanmy on 2019/11/21.
//  Copyright © 2019 sanmy. All rights reserved.
//

import Foundation


/// Cache type of a cached object.
/// - none: The object is not cached yet when retrieving it.
/// - memory: The object is cached in memory.
/// - disk: The object is cached in disk.
public enum CacheType {
    /// The object is not cached yet when retrieving it.
    case none
    /// The object is cached in memory.
    case memory
    /// The object is cached in disk.
    case disk
    
    /// Whether the cache type represents the object is already cached or not.
    public var cached: Bool {
        switch self {
        case .memory, .disk: return true
        case .none: return false
        }
    }
}

/// Represents the caching operation result.
public struct CacheStoreResult {
    
    /// The cache result for memory cache. Caching an object to memory will never fail.
    public let memoryCacheResult: Result<(), Never>
    
    /// The cache result for disk cache. If an error happens during caching operation,
    /// you can get it from `.failure` case of this `diskCacheResult`.
    public let diskCacheResult: Result<(), CacheError>
}



open class Cache {
    
    public static let `default` = Cache()
    
    public let memoryStorage: MemoryStorage.Backend<KFCrossPlatformImage>
    
    public let diskStorage: DiskStorage.Backend<Data>
    
    private let ioQueue: DispatchQueue
    
    /// Closure that defines the disk cache path from a given path and cacheName.
    public typealias DiskCachePathClosure = (URL, String) -> URL
    
    
    public init(memoryStorage: MemoryStorage.Backend<KFCrossPlatformImage>,
                diskStorage: DiskStorage.Backend<Data>) {
        
        
    }
  
}

