//
//  CacheError.swift
//  SSYCache
//
//  Created by sanmy on 2019/11/21.
//  Copyright © 2019 sanmy. All rights reserved.
//

import Foundation

public enum CacheError: Error {
    
    /// Cannot create a file enumerator for a certain disk URL. Code 3001.
    /// - url: The target disk URL from which the file enumerator should be created.
    case fileEnumeratorCreationFailed(url: URL)
    
    /// Cannot get correct file contents from a file enumerator. Code 3002.
    /// - url: The target disk URL from which the content of a file enumerator should be got.
    case invalidFileEnumeratorContent(url: URL)
    
    /// The file at target URL exists, but its URL resource is unavailable. Code 3003.
    /// - error: The underlying error thrown by file manager.
    /// - key: The key used to getting the resource from cache.
    /// - url: The disk URL where the target cached file exists.
    case invalidURLResource(error: Error, key: String, url: URL)
    
    /// The file at target URL exists, but the data cannot be loaded from it. Code 3004.
    /// - url: The disk URL where the target cached file exists.
    /// - error: The underlying error which describes why this error happens.
    case cannotLoadDataFromDisk(url: URL, error: Error)
    
    /// Cannot create a folder at a given path. Code 3005.
    /// - path: The disk path where the directory creating operation fails.
    /// - error: The underlying error which describes why this error happens.
    case cannotCreateDirectory(path: String, error: Error)
    
    /// The requested image does not exist in cache. Code 3006.
    /// - key: Key of the requested image in cache.
    case imageNotExisting(key: String)
    
    /// Cannot convert an object to data for storing. Code 3007.
    /// - object: The object which needs be convert to data.
    case cannotConvertToData(object: Any, error: Error)
    
    /// Cannot serialize an image to data for storing. Code 3008.
    /// - image: The input image needs to be serialized to cache.
    /// - original: The original image data, if exists.
    /// - serializer: The `CacheSerializer` used for the image serializing.
//    case cannotSerializeImage(image: KFCrossPlatformImage?, original: Data?, serializer: CacheSerializer)
}
