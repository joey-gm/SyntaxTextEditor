//
//  SyntaxPattern.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

import Foundation

enum SyntaxType {
    case plain
    case number
    case string
    case keyword
    case comment
    case markup
    case preprocessor
    case url
    case declaration    // Type Declaration
    case declaration2   // Other Declaration
    case identifier     // Class/Type Names
    case identifier2    // Function/Method/Constant/Instance Variable/Globals Names
    case identifier3    // Project Class/Type Names
    case identifier4    // Project Function/Method/Constant/Instance Variable/Globals Names
}

struct SyntaxPattern: Hashable {
    
    let keywords: Set<String>?
    let regex: NSRegularExpression?
    let type: SyntaxType
    var attributes: [NSAttributedString.Key: AnyHashable]
    
    init(_ keywords: Set<String>, type: SyntaxType, attrs: [NSAttributedString.Key: AnyHashable]) {
        self.keywords = keywords
        self.regex = nil
        self.type = type
        self.attributes = attrs
    }
    
    init(_ regex: NSRegularExpression, type: SyntaxType, attrs: [NSAttributedString.Key: AnyHashable]) {
        self.keywords = nil
        self.regex = regex
        self.type = type
        self.attributes = attrs
    }
    
}
