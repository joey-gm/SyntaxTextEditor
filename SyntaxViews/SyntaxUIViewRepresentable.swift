//
//  SyntaxUIViewRepresentable.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

import SwiftUI

#if os(iOS)

struct SyntaxTextView: UIViewRepresentable {
    
    @Binding var document: Document
    @Binding var lexer: Lexer
    
    func makeUIView(context: Context) -> UITextView {
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: 0, height: 0))
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let textView = UITextView(frame: .zero, textContainer: textContainer)
        textView.delegate = context.coordinator
        textView.backgroundColor = lexer.theme.backgroundColor
        textView.font = lexer.theme.font
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.autoresizingMask = [.flexibleWidth]
        textView.isEditable = true
        textView.autocorrectionType = .no
        textView.text = document.text
        processSyntax(textView)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.backgroundColor = lexer.theme.backgroundColor
        processSyntax(uiView)
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: SyntaxTextView
        
        init(_ parent: SyntaxTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.processSyntax(textView)
            parent.document.text = textView.text
            parent.document.updateChangeCount(.done)
        }
    }
    
    
    private func processSyntax(_ textView: UITextView) {
        guard let text = textView.text else { return }
        let textStorage = textView.textStorage
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
