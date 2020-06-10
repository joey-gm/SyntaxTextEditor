//
//  Document.swift
//  Syntax_macOS
//
//  Created by Joey
//

#if os(macOS)

import Cocoa

class Document: NSDocument {
    
    override init() {
        super.init()
        let theme: SyntaxTheme = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" ? DarkTheme(): LightTheme()
        let lexer = SwiftLexer(theme)
        self.syntaxVC = SyntaxViewController(lexer: lexer)
    }
    
    var syntaxVC: SyntaxViewController!
    
    override func makeWindowControllers() {
        syntaxVC.representedObject = self
        let window = NSWindow(contentViewController: syntaxVC)
        window.setContentSize(NSSize(width: 800, height: 600))
        let wc = NSWindowController(window: window)
        addWindowController(wc)
        window.makeKeyAndOrderFront(nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        guard let str = String(data: data, encoding: .utf8) else { throw DocError.unsupportedDoc }
        syntaxVC.text = str
    }
    
    override func data(ofType typeName: String) throws -> Data {
        return syntaxVC.text.data(using: .utf8)!
    }
    
    enum DocError: Error {
        case unsupportedDoc
    }

}

#endif
