//
//  SyntaxTheme.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

#if os(macOS)

import Cocoa
public typealias Font           = NSFont
public typealias Color          = NSColor

#elseif os(iOS)

import UIKit
public typealias Font           = UIFont
public typealias Color          = UIColor

#endif


protocol SyntaxTheme {
    var font: Font { get }
    var lineHeightMultiple: CGFloat { get }
    var backgroundColor: Color { get }
    func color(for type: SyntaxType) -> Color
}


extension SyntaxTheme {
    
    func globalAttributes() -> [NSAttributedString.Key: AnyHashable] {
        var attributes = [NSAttributedString.Key: AnyHashable]()
        attributes[.font] = font
        attributes[.foregroundColor] = color(for: .plain)
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
    
    func attributes(for type: SyntaxType) -> [NSAttributedString.Key: AnyHashable] {
        var attributes = [NSAttributedString.Key: AnyHashable]()
        attributes[.foregroundColor] = color(for: type)
        switch type {
        case .keyword: attributes[.font] = boldFont
        case .string: attributes[.font] = font
        case .comment: attributes[.font] = font
        default: break
        }
        return attributes
    }
    
    
    var boldFont: Font {
        get {
            #if os(macOS)
            if #available(macOS 10.15, *) {
                if font.fontName.hasPrefix(".AppleSystemUIFont") {
                    return NSFont.boldSystemFont(ofSize: font.pointSize)
                } else if font.fontName.hasPrefix(".SFNSMono-") {
                    return NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .bold)
                } else if font.fontName.hasPrefix(".SFNS-") {
                    return NSFont.monospacedDigitSystemFont(ofSize: font.pointSize, weight: .bold)
                }
            }
            return NSFont(descriptor: font.fontDescriptor.withSymbolicTraits(.bold), size: font.pointSize) ?? font
            
            #elseif os(iOS)
            return UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize)
            #endif
        }
    }
    
    var paragraphStyle: NSMutableParagraphStyle {
        get {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = self.lineHeightMultiple
            return paragraphStyle
        }
    }
    
}
