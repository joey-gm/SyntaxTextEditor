//
//  SyntaxViewControllerExt.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif


extension SyntaxViewController {
    
    convenience init(lexer: Lexer) {
        self.init()
        self.theme = lexer.theme
        self.lexer = lexer
    }
    
    var textStorage: NSTextStorage {
        get {
            #if os(macOS)
            return textView.textStorage!
            #else
            return textView.textStorage
            #endif
        }
    }
    
    func processSyntax() {
        guard let lexer = lexer else { return }
        if !text.isEmpty {
            
            textStorage.beginEditing()
            
            let range = NSRange(location: 0, length: (text as NSString).length)
            textStorage.setAttributes(theme?.globalAttributes(), range: range)
            
            lexer.getTokens(for: text).forEach { tokens in
                tokens.forEach { token in
                    textStorage.addAttributes(token.attributes, range: token.range)
                }
            }
            textStorage.endEditing()
        }
    }
    
}

extension SyntaxViewController {
    
    #if os(macOS)
    
    override func loadView() {
        // Setup NSTextStorage
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude))
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textView.replaceTextContainer(textContainer)
        // Setup NSTextView
        textView.textContainerInset = CGSize(width: 20, height: 20)
        textView.autoresizingMask = [.width]
        textView.isEditable = true
        textView.backgroundColor = theme!.backgroundColor
        textView.delegate = self
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView
        self.view = scrollView
        processSyntax()
    }
    
    
    
    #elseif os(iOS)
    
    override func loadView() {
        // Setup NSTextStorage
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: 0, height: 0))
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textView = UITextView(frame: .zero, textContainer: textContainer)
        // Setup NSTextView
        textView.delegate = self
        textView.backgroundColor = theme!.backgroundColor
        textView.font = theme!.font
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.autoresizingMask = [.flexibleWidth]
        textView.isEditable = true
        textView.autocorrectionType = .no
        textView.isEditable = true
        self.view = textView
        processSyntax()
    }
    
    #endif
    
}
