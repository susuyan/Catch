//
//  SSYCacheProtocol.swift
//  SSYCache
//
//  Created by sanmy on 2019/11/14.
//  Copyright © 2019 sanmy. All rights reserved.
//

import Foundation


public typealias Completion = () -> Void

public typealias Progression = (_ removedCount: Int, _ totalCount: Int) -> Void


protocol CacheProtocol: AccessProtocol, TrimProtocol {
    
    var name: String? {set get}
    
    var path: String? {get}
    
    // MARK: - Limit
    
    var countLimit: UInt {set get}
    
    var costLimit: UInt {set get}
    
    var ageLimit: UInt {set get}
    
    var freeDiskSpaceLimit: UInt {set get}
    
    var autoTrimInterval: UInt {set get}
    
}

protocol AccessProtocol {
    
    func containsObjectForKey(key: AnyObject) -> Bool
    
    func containsObjectForKey(key: AnyObject, completion: Completion) -> Bool
    
    func objectForKey(key: AnyObject) -> AnyObject?
    
    func objectForKey(key: AnyObject, completion: Completion) -> AnyObject?
    
    func setObject(_ object: AnyObject?, forKey key: AnyObject)
    
    func setObject(_ object: AnyObject?, forKey key: AnyObject, completion: Completion)
    
    func setObject(_ object: AnyObject?, forKey key: AnyObject, withCost cost: Unit)
    
    func removeObjectForKey(key: String)
    
    func removeObjectForKey(key: String, completion: Completion)
    
    func removeAllObjects()
    
    func removeAllObjects(completion: Completion)
    
}

extension AccessProtocol {
    
    func containsObjectForKey(key: AnyObject, completion: Completion) -> Bool{
        return false
    }
    
    func objectForKey(key: AnyObject, completion: Completion) -> AnyObject? {
        return nil
    }
    func setObject(_ object: AnyObject?, forKey key: AnyObject, completion: Completion){}
    func removeObjectForKey(key: String, completion: Completion){}
    func removeAllObjects(completion: Completion){}
    
}


protocol TrimProtocol {
    
    func trimToCount(count: UInt)
    
    func trimToCount(count: UInt, completion: Completion)

    func trimToCost(cost: UInt)
    
    func trimToCost(cost: UInt, completion: Completion)
    
    func trimToAge(age: TimeInterval)
    
    func trimToAge(age: TimeInterval, completion: Completion)
    
}

extension TrimProtocol {
    
    func trimToCount(count: UInt, completion: Completion){}
    func trimToCost(cost: UInt, completion: Completion){}
    func trimToAge(age: TimeInterval, completion: Completion){}
    
}

