//
//  Document.swift
//  Syntax_iOS
//
//  Created by Joey
//

import UIKit

class Document: UIDocument {
    
    var text: String = ""
    
    override func contents(forType typeName: String) throws -> Any {
        guard let data = text.data(using: .utf8) else { throw DocError.unableToEncode }
        return data
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data, let str = String(data: data, encoding: .utf8) else { throw DocError.unsupportedDoc }
        text = str
    }
    
    init() {
        let tempDir = FileManager.default.temporaryDirectory
        let url = tempDir.appendingPathComponent("MyTextDoc.txt")
        
        super.init(fileURL: url)
    }
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
    }
    
    enum DocError: Error {
        case unsupportedDoc
        case unableToEncode
    }
    
}
