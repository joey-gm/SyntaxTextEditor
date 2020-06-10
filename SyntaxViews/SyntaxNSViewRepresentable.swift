//
//  SyntaxNSViewRepresentable.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

import SwiftUI

#if os(macOS)

struct SyntaxTextView: NSViewRepresentable {
    
    @Binding var document: Document
    @Binding var lexer: Lexer
    
    func makeNSView(context: Context) -> NSTextView {
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: 0, height: 0))
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.delegate = context.coordinator
        textView.backgroundColor = lexer.theme.backgroundColor
        textView.font = lexer.theme.font
        textView.textContainerInset = CGSize(width: 20, height: 20)
        textView.autoresizingMask = [.width]
        textView.isEditable = true
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.string = document.text
        processSyntax(textView)
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.backgroundColor = lexer.theme.backgroundColor
        processSyntax(nsView)
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator: NSObject, NSTextViewDelegate {
        
        let parent: SyntaxTextView
        
        init(_ parent: SyntaxTextView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.processSyntax(textView)
                parent.document.text = textView.string
                parent.document.updateChangeCount(.changeDone)
            }
        }
    }
    
    
    private func processSyntax(_ textView: NSTextView) {
        guard let textStorage = textView.textStorage else { return }
        let text = textView.string
        let range = NSRange(location: 0, length: (text as NSString).length)
        textStorage.beginEditing()
        textStorage.setAttributes(lexer.theme.globalAttributes(), range: range)
        lexer.getTokens(for: text).forEach { tokens in
            tokens.forEach { token in
                textStorage.addAttributes(token.attributes, range: token.range)
            }
        }
        textStorage.endEditing()
    }
    
    
}

#endif
