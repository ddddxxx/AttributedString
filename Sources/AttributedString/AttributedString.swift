//
//  AttributedString.swift
//  AttributedString
//
//  Created by ddddxxx on 2018/10/17.
//

import Foundation
#if canImport(Cocoa)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif

public struct AttributedString {
    
    public typealias EnumerationOptions = NSAttributedString.EnumerationOptions
    
    public class Keys: RawRepresentable {
        
        public var rawValue: String
        
        required public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public final class Key<T>: Keys {}
    
    enum Backing {
        case immutable(NSAttributedString)
        case mutable(NSMutableAttributedString)
        
        var immutableValue: NSAttributedString {
            switch self {
            case let .immutable(str): return str
            case let .mutable(str): return str
            }
        }
        
        mutating func uniqueMutableValue() -> NSMutableAttributedString {
            if case var .mutable(str) = self, isKnownUniquelyReferenced(&str) {
                return str
            }
            let newStr = immutableValue.mutableCopy() as! NSMutableAttributedString
            self = .mutable(newStr)
            return newStr
        }
    }
    
    private var _backing: Backing
    
    private init(_ attributedString: NSAttributedString) {
        _backing = .immutable(attributedString.copy() as! NSAttributedString)
    }
    
    public init(_ string: String, attributes: [Keys: Any] = [:]) {
        let attrString = NSAttributedString(string: string, attributes: attributes.asFoundation)
        self.init(attrString)
    }
    
    @available(OSX 10.11, *)
    public init(image: Image) {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attrString =  NSAttributedString(attachment: attachment)
        self.init(attrString)
    }
}

// MARK: -
    
extension AttributedString {
    
    public var string: String {
        return _backing.immutableValue.string
    }
    
    public var length: Int {
        return _backing.immutableValue.length
    }
    
    private var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    public func substring(with range: NSRange) -> AttributedString {
        let attrString = _backing.immutableValue.attributedSubstring(from: range)
        return AttributedString(attrString)
    }
    
    public func attributes(at index: Int) -> [Keys : Any] {
        let attr = _backing.immutableValue.attributes(at: index, effectiveRange: nil)
        return attr.asSwift
    }
    
    public func attributes(at index: Int, in range: NSRange? = nil) -> ([Keys: Any], longestEffectiveRange: NSRange) {
        var longestEffectiveRange = NSRange(location: 0, length: 0)
        let attr = _backing.immutableValue.attributes(at: index, longestEffectiveRange: &longestEffectiveRange, in: range ?? fullRange)
        return (attr.asSwift, longestEffectiveRange)
    }
    
    public func attribute<T>(name: Key<T>, at index: Int) -> T? {
        guard let attr = _backing.immutableValue.attribute(name.asFoundation, at: index, effectiveRange: nil),
            let typedAttr = attr as? T else {
            return nil
        }
        return typedAttr
    }
    
    public func attribute<T>(name: Key<T>, at index: Int, in range: NSRange? = nil) -> (T, longestEffectiveRange: NSRange)? {
        var longestEffectiveRange = NSRange(location: 0, length: 0)
        guard let attr = _backing.immutableValue.attribute(name.asFoundation, at: index, longestEffectiveRange: &longestEffectiveRange, in: range ?? fullRange),
            let typedAttr = attr as? T else {
            return nil
        }
        return (typedAttr, longestEffectiveRange)
    }
    
    func enumerateAttribute<T>(name: Key<T>, in range: NSRange? = nil, options: EnumerationOptions = [], using: (T?, NSRange, inout Bool) -> Void) {
        _backing.immutableValue.enumerateAttribute(name.asFoundation, in: range ?? fullRange, options: options) { (val, range, pstop) in
            var stop = false
            let typedVal = val as? T
            using(typedVal, range, &stop)
            pstop.pointee = ObjCBool(stop)
        }
    }
    
    func enumerateAttributes(in range: NSRange? = nil, options: EnumerationOptions = [], using: ([Keys: Any], NSRange, inout Bool) -> Void) {
        _backing.immutableValue.enumerateAttributes(in: range ?? fullRange, options: options) { (attrs, range, pstop) in
            var stop = false
            using(attrs.asSwift, range, &stop)
            pstop.pointee = ObjCBool(stop)
        }
    }
    
    public mutating func set(attributes: [Keys: Any], in range: NSRange? = nil) {
        _backing.uniqueMutableValue().setAttributes(attributes.asFoundation, range: range ?? fullRange)
    }
    
    public mutating func add<T>(attribute: Key<T>, value: T, in range: NSRange? = nil) {
        _backing.uniqueMutableValue().addAttribute(attribute.asFoundation, value: value, range: range ?? fullRange)
    }
    
    public mutating func add(attributes: [Keys: Any], in range: NSRange? = nil) {
        _backing.uniqueMutableValue().addAttributes(attributes.asFoundation, range: range ?? fullRange)
    }
    
    public mutating func remove(attribute: Keys, in range: NSRange? = nil) {
        _backing.uniqueMutableValue().removeAttribute(attribute.asFoundation, range: range ?? fullRange)
    }
    
    public mutating func append(_ attributedString: AttributedString) {
        _backing.uniqueMutableValue().append(attributedString._backing.immutableValue)
    }
    
    public mutating func insert(_ attributedString: AttributedString, at index: Int) {
        _backing.uniqueMutableValue().insert(attributedString._backing.immutableValue, at: index)
    }
    
    public mutating func replaceCharacters(in range: NSRange, with attributedString: AttributedString) {
        _backing.uniqueMutableValue().replaceCharacters(in: range, with: attributedString._backing.immutableValue)
    }
    
}

// MARK: -

public extension AttributedString {
    
    subscript<T>(attrName: Key<T>, in range: NSRange) -> T? {
        get {
            guard let (val, attrRange) = attribute(name: attrName, at: range.location, in: range), attrRange.contains(range) else {
                return nil
            }
            return val
        }
        mutating set {
            guard let val = newValue else {
                remove(attribute: attrName, in: range)
                return
            }
            add(attribute: attrName, value: val, in: range)
        }
    }
    
    subscript<T>(attrName: Key<T>) -> T? {
        get {
            return self[attrName, in: fullRange]
        }
        mutating set {
            self[attrName, in: fullRange] = newValue
        }
    }
    
    subscript(range: NSRange)-> AttributedString {
        get {
            return substring(with: range)
        }
        set {
            replaceCharacters(in: range, with: newValue)
        }
    }
    
    subscript<R>(range: R)-> AttributedString where R: RangeExpression, R.Bound == Int {
        get {
            let r = NSRange(range)
            return self[r]
        }
        set {
            let r = NSRange(range)
            self[r] = newValue
        }
    }
    
    static func +=(lhs: inout AttributedString, rhs: AttributedString) {
        lhs.append(rhs)
    }
    
    static func +(lhs: AttributedString, rhs: AttributedString) -> AttributedString {
        var str = lhs
        str += rhs
        return str
    }
}

// MARK: -

extension AttributedString: Equatable, Hashable {
    
    public static func == (lhs: AttributedString, rhs: AttributedString) -> Bool {
        return lhs._backing.immutableValue == rhs._backing.immutableValue
    }
    
    public var hashValue: Int {
        return _backing.immutableValue.hashValue
    }
}

extension AttributedString: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return _backing.immutableValue.description
    }
    
    public var debugDescription: String {
        return _backing.immutableValue.debugDescription
    }
}

extension AttributedString: ReferenceConvertible {
    
    public typealias ReferenceType = NSAttributedString
    public typealias _ObjectiveCType = NSAttributedString
    
    public func _bridgeToObjectiveC() -> NSAttributedString {
        return _backing.immutableValue
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) {
        result = AttributedString(source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) -> Bool {
        result = AttributedString(source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSAttributedString?) -> AttributedString {
        return AttributedString(source!)
    }
}

extension AttributedString: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension AttributedString: CustomPlaygroundDisplayConvertible {
    
    public var playgroundDescription: Any {
        return _backing.immutableValue
    }
}
