//
//  Runtime.swift
//  Catch
//
//  Created by sanmy on 2019/12/7.
//  Copyright © 2019 susuyan. All rights reserved.
//

import Foundation


func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
