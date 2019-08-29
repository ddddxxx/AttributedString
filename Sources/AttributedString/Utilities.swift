import Foundation

#if canImport(Cocoa)

import Cocoa

public typealias Font = NSFont
public typealias Color = NSColor
public typealias Image = NSImage

#elseif canImport(UIKit)

import UIKit

public typealias Font = UIFont
public typealias Color = UIColor
public typealias Image = UIImage

#endif

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    
    var asSwift: [AttributedString.Keys: Any] {
        var result = Dictionary<AttributedString.Keys, Any>(minimumCapacity: count)
        for (key, value) in self {
            result[key.asSwift] = value
        }
        return result
    }
}

extension Dictionary where Key == AttributedString.Keys, Value == Any {
    
    var asNS: [NSAttributedString.Key: Any] {
        var result = Dictionary<NSAttributedString.Key, Any>(minimumCapacity: count)
        for (key, value) in self {
            result[key.asNS] = value
        }
        return result
    }
}

extension NSAttributedString.Key {
    
    var asSwift: AttributedString.Keys {
        return AttributedString.Keys(rawValue)
    }
}

extension AttributedString.Keys {
    
    var asNS: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue)
    }
}

extension NSRange {
    
    func contains(_ other: NSRange) -> Bool {
        return lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }
}
