import Foundation

#if canImport(Cocoa)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif

extension AttributedString.Keys {
    
    public convenience init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
    
    public convenience init(_ key: NSAttributedString.Key) {
        self.init(rawValue: key.rawValue)
    }
    
    private convenience init(ns key: NSAttributedString.Key) {
        self.init(rawValue: key.rawValue)
    }
}

extension AttributedString.Keys: Equatable, Hashable {
    
    public static func == (lhs: AttributedString.Keys, rhs: AttributedString.Keys) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

public extension AttributedString.Keys {
    
    static let font = AttributedString.Key<Font>(ns: .font)
    
    static let paragraphStyle = AttributedString.Key<NSParagraphStyle>(ns: .paragraphStyle)
    
    static let foregroundColor = AttributedString.Key<Color>(ns: .foregroundColor)
    
    static let backgroundColor = AttributedString.Key<Color>(ns: .backgroundColor)
    
    static let ligature = AttributedString.Key<Int>(ns: .ligature)
    
    static let kern = AttributedString.Key<Double>(ns: .kern)
    
    static let strikethroughStyle = AttributedString.Key<NSUnderlineStyle>(ns: .strikethroughStyle)
    
    static let underlineStyle = AttributedString.Key<NSUnderlineStyle>(ns: .underlineStyle)
    
    static let strokeColor = AttributedString.Key<Color>(ns: .strokeColor)
    
    static let strokeWidth = AttributedString.Key<Double>(ns: .strokeWidth)
    
    @available(macOS 10.10, *)
    static let textEffect = AttributedString.Key<NSAttributedString.TextEffectStyle>(ns: .textEffect)
    
    static let link = AttributedString.Key<URL>(ns: .link)
    
    static let baselineOffset = AttributedString.Key<Double>(ns: .baselineOffset)
    
    static let underlineColor = AttributedString.Key<Color>(ns: .underlineColor)
    
    static let strikethroughColor = AttributedString.Key<Color>(ns: .strikethroughColor)
    
    static let obliqueness = AttributedString.Key<Double>(ns: .obliqueness)
    
    static let expansion = AttributedString.Key<Double>(ns: .expansion)
    
    static let writingDirection = AttributedString.Key<[Int]>(ns: .writingDirection)
    
    static let verticalGlyphForm = AttributedString.Key<Int>(ns: .verticalGlyphForm)
    
    #if !os(watchOS)
    
    static let shadow = AttributedString.Key<NSShadow>(ns: .shadow)
    
    static let attachment = AttributedString.Key<NSTextAttachment>(ns: .attachment)
    
    #endif
    
    #if os(macOS)
    
    static let cursor = AttributedString.Key<NSCursor>(ns: .cursor)
    
    static let toolTip = AttributedString.Key<String>(ns: .toolTip)
    
    static let markedClauseSegment = AttributedString.Key<Int>(ns: .markedClauseSegment)
    
    static let textAlternatives = AttributedString.Key<NSTextAlternatives>(ns: .textAlternatives)
    
    @available(macOS 10.13, *)
    static let spellingState = AttributedString.Key<NSAttributedString.SpellingState>(ns: .spellingState)
    
    static let superscript = AttributedString.Key<Int>(ns: .superscript)
    
    static let glyphInfo = AttributedString.Key<NSGlyphInfo>(ns: .glyphInfo)
    
    #endif
}
