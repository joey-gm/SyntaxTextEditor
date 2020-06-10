//
//  Lexer.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

import Foundation

struct Token: Hashable {
    var attributes: [NSAttributedString.Key: AnyHashable]
    var range: NSRange
}

protocol Lexer {
    var theme: SyntaxTheme { get set }
    var declarationPatterns:    Set<SyntaxPattern>? { get set }
    var keywordsPatterns:       Set<SyntaxPattern>? { get set }
    var regexPatterns:          Set<SyntaxPattern>? { get set }
    var numericPatterns:        Set<SyntaxPattern>? { get set }
    var stringPatterns:         Set<SyntaxPattern>? { get set }
    var commentPatterns:        Set<SyntaxPattern>? { get set }
}

extension Lexer {
    
    func getTokens(for text: String) ->  [Set<Token>] {
        
        let fullRange = NSRange(location: 0, length: text.utf16.count)
        var tokensArray = [Set<Token>]()
        var tokens = Set<Token>()
        let nsText = text as NSString
                
        // I: User declarations
        var userDeclarations = Set<String>()
        var userTokens = Set<Token>()
        declarationPatterns?.forEach { pattern in
            pattern.regex?.matches(in: text, options: [], range: fullRange).forEach { match in
                userDeclarations.insert(String(text[Range(match.range, in: text)!]))
                tokens.insert(Token(attributes: pattern.attributes, range: match.range))
            }
        }
        let userAttrs = theme.attributes(for: .identifier3)
        userDeclarations.forEach { userDeclaration in
            if let regex = try? NSRegularExpression(pattern: "\\b\(userDeclaration)\\b", options: []) {
                regex.matches(in: text, options: [], range: fullRange).forEach { match in
                    userTokens.insert(Token(attributes: userAttrs, range: match.range))
                }
            }
        }
        tokensArray.append(userTokens)
     
        // II: Generics
        keywordsPatterns?.forEach { pattern in
            nsText.enumerateSubstrings(in: fullRange, options: .byWords) { (word: String?, range: NSRange, _, _) in
                if let word = word, pattern.keywords!.contains(word) {
                    tokens.insert(Token(attributes: pattern.attributes, range: range))
                }
            }
        }
        regexPatterns?.forEach { pattern in
            pattern.regex?.matches(in: text, options: [], range: fullRange).forEach { match in
                tokens.insert(Token(attributes: pattern.attributes, range: match.range))
            }
        }
        tokensArray.append(tokens)
        
        // III: String then Comments
        [numericPatterns, stringPatterns, commentPatterns].forEach { patterns in
            tokens.removeAll()
            patterns?.forEach { pattern in
                pattern.regex?.matches(in: text, options: [], range: fullRange).forEach { match in
                    tokens.insert(Token(attributes: pattern.attributes, range: match.range))
                }
            }
            tokensArray.append(tokens)
        }
        
        return tokensArray
    }
    
    mutating func updateTheme(_ newTheme: SyntaxTheme) {
        theme = newTheme
        for (index, patterns) in [declarationPatterns, keywordsPatterns, regexPatterns, numericPatterns, stringPatterns, commentPatterns].enumerated() {
            var newSet = Set<SyntaxPattern>()
            patterns?.forEach { pattern in
                var newPattern = pattern
                newPattern.attributes = theme.attributes(for: pattern.type)
                newSet.insert(pattern)
            }
            switch index {
            case 0: self.declarationPatterns = newSet
            case 1: self.keywordsPatterns = newSet
            case 2: self.regexPatterns = newSet
            case 3: self.numericPatterns = newSet
            case 4: self.stringPatterns = newSet
            case 5: self.commentPatterns = newSet
            default: break
            }
        }
    }
    
    
    func keywordsPattern(_ keywords: Set<String>, type: SyntaxType) -> SyntaxPattern {
        return SyntaxPattern(keywords, type: type, attrs: theme.attributes(for: type))
    }
    
    
    func regexPattern(_ regex: String, options: NSRegularExpression.Options = [], type: SyntaxType) -> SyntaxPattern? {
        guard let nsRegex = try? NSRegularExpression(pattern: regex, options: options) else { return nil }
        return SyntaxPattern(nsRegex, type: type, attrs: theme.attributes(for: type))
    }
    
}
