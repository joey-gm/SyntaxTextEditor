//
//  DocumentView.swift
//  Syntax_SwiftUI
//
//  Created by Joey
//

import SwiftUI

struct DocumentView: View {
    @State var document: Document
    @State var lexer: Lexer = SwiftLexer(DarkTheme())
    var dismiss: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                SyntaxTextView(document: $document, lexer: $lexer)
            }
            VStack {
                Spacer()
                Button("Done", action: dismiss)
            }
        }
    }
}

