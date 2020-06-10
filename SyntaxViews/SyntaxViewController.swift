//
//  SyntaxViewController.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

#if os(macOS)

import Cocoa

class SyntaxViewController: NSViewController, NSTextViewDelegate {

    let textView = NSTextView()
    
    @objc var text: String {
        get { return textView.string }
        set {
            textView.string = newValue
            processSyntax()
        }
    }
    
    var lexer: Lexer?
    
    var theme: SyntaxTheme? {
        didSet {
            guard let theme = theme else { return }
            textView.backgroundColor = theme.backgroundColor
            textView.font = theme.font
            lexer?.updateTheme(theme)
            processSyntax()
        }
    }
    
    func textDidChange(_ notification: Notification) {
        if (notification.object as? NSTextView) != nil {
            processSyntax()
        }
    }
    
}

#elseif os(iOS)

import UIKit

class SyntaxViewController: UIViewController, UITextViewDelegate {
    
    var textView = UITextView()
    
    @objc var text: String {
        get { return textView.text }
        set {
            textView.text = newValue
            processSyntax()
        }
    }
    
    var lexer: Lexer?
    
    var theme: SyntaxTheme? {
        didSet {
            guard let theme = theme else { return }
            textView.backgroundColor = theme.backgroundColor
            textView.font = theme.font
            lexer?.updateTheme(theme)
            processSyntax()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        processSyntax()
    }
    
}

#endif
