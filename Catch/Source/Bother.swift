//
//  Bother.swift
//  Catch
//
//  Created by sanmy on 2019/12/7.
//  Copyright © 2019 susuyan. All rights reserved.
//

import Foundation


public struct BotherWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}


public protocol BotherCompatible: AnyObject { }


public protocol BotherCompatibleValue {}


extension BotherCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var bt: BotherWrapper<Self> {
        get { return BotherWrapper(self) }
        set { }
    }
}


extension BotherCompatibleValue {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var bt: BotherWrapper<Self> {
        get { return BotherWrapper(self) }
        set { }
    }
}
