//
//  SwiftLexer.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

import Foundation

struct SwiftLexer: Lexer {
    
    var theme: SyntaxTheme
    var declarationPatterns:    Set<SyntaxPattern>?
    var keywordsPatterns:       Set<SyntaxPattern>?
    var regexPatterns:          Set<SyntaxPattern>?
    var numericPatterns:        Set<SyntaxPattern>?
    var stringPatterns:         Set<SyntaxPattern>?
    var commentPatterns:        Set<SyntaxPattern>?
    
    init(_ theme: SyntaxTheme) {
        
        self.theme = theme
        
        // I: Setup Declaration Patterns
        // Type Declaration
        if let declarationPattern = regexPattern("(?<=\\bstruct |\\bclass |\\benum |\\bprotocol )([a-zA-Z0-9_$]+)", type: .declaration) {
            self.declarationPatterns = Set(arrayLiteral: declarationPattern)
        }
        
        // II: Setup Keywords Patterns
        var keywordsSet = Set<SyntaxPattern>()
        
        let keywords = "as associatedtype break case catch class continue convenience default defer deinit else enum extension fallthrough false fileprivate final for func get guard if import in init inout internal is lazy let mutating nil nonmutating open operator override private protocol public repeat required rethrows return required self set static struct subscript super switch throw throws true try typealias unowned var weak where while Any".components(separatedBy: " ")
        keywordsSet.insert(keywordsPattern(Set(keywords), type: .keyword))
        
        // Standard Swift Library
        // Numbers, Basic Values, Strings and Text
        var identifiers = "Bool Int Double Float Range ClosedRange Error Result Optional UInt UInt8 UInt16 UInt32 UInt64 Int8 Int16 Int32 Int64 Float32 Float64 Float80 AdditiveArithmetic Numeric SignedNumeric Strideable BinaryInteger FixedWidthInteger SignedInteger UnsignedInteger FloatingPoint BinaryFloatingPoint String Substring Character Unicode StaticString AnyObject AnyClass "
        // Collection
        identifiers += "Array Dictionary Set OptionSet Range ClosedRange CollectionOfOne EmptyCollection KeyValuePairs Sequence Collection BidirectionalCollection RandomAccessCollection MutableCollection RangeReplaceableCollection IteratorProtocol SetAlgebra LazySequenceProtocol LazyCollectionProtocol Slice PartialRangeUpTo PartialRangeThrough PartialRangeFrom RangeExpression UnboundedRange AnySequence AnyCollection AnyBidirectionalCollection AnyRandomAccessCollection AnyIterator AnyIndex AnyHashable CollectionDifference DropFirstSequence DropWhileSequence EnumeratedSequence FlattenCollection FlattenSequence JoinedSequence PrefixSequence Repeated ReversedCollection StrideTo StrideThrough UnfoldSequence Zip2Sequence DefaultIndices IteratorSequence IndexingIterator SetIterator StrideToIterator DictionaryIndex SetIndex CountableRange CountableClosedRange CountablePartialRangeFrom "
       // Basic Behaviors, Encoding, Decoding, and Serialization
        identifiers += "Equatable Comparable Hashable Hasher CustomStringConvertible LosslessStringConvertible CustomDebugStringConvertible CaseIterable RawRepresentable Codable Encodable Decodable CodingKey CodingUserInfoKey Encoder Decoder EncodingError DecodingError JSONEncoder JSONDecoder JSONSerialization "
        // Manual Memory Management
        identifiers += "UnsafePointer UnsafeBufferPointer UnsafeRawPointer UnsafeRawBufferPointer UnsafeMutablePointer UnsafeMutableBufferPointer UnsafeMutableRawPointer UnsafeMutableRawBufferPointer "
        // Core Graphics
        identifiers += "CGFloat CGPoint CGSize CGRect CGVector CGAffineTransform CGContext CGImage CGPath CGMutablePath CGLayer CGColor CGColorConversionInfo CGColorSpace CGFont CGPDFDocument CGDataConsumer CGDataProvider CGShading CGGradient CGFunction CGPattern CGPathFillRule CGPDFAccessPermissions CGPSConverter CGPSConverterCallbacks "
        // Misc
        identifiers += "Data UTF8 UTF16 UTF32 NumberFormatter FileHandle "
        keywordsSet.insert(keywordsPattern(Set(identifiers.components(separatedBy: " ")), type: .identifier))
        
        self.keywordsPatterns = keywordsSet
        
        // III: Setup Regex Patterns
        var regexArray = [SyntaxPattern?]()
        // Other Declaration
        regexArray.append(regexPattern("(?<=\\bvar |\\blet |\\bfunc )([a-zA-Z0-9_$]+)", type: .declaration2))
        // Keywords Attributes
        regexArray.append(regexPattern("#available\\b|@available\\b|@IBOutlet\\b|@objc\\b|@dynamicCallable\\b|@dynamicMemberLookup\\b", type: .keyword))
        // NS UI class?
        regexArray.append(regexPattern("\\b(NS|UI)[A-Z][a-zA-Z]+\\b", type: .identifier))
        // Operators
        regexArray.append(regexPattern("(==|===|!=|!==|\\*=|\\/=|%=x|\\+=|-=|&&|<=|>=|\\.\\.<|\\.\\.\\.)", type: .identifier2))
        // print
        regexArray.append(regexPattern("\\b(print)(?=\\()", type: .identifier2))
        // .Method? (?<=\.)\w*
        regexArray.append(regexPattern("(?<=[^\\d]\\w\\.)\\w*", type: .identifier2))
        // Hexadecimal number with a 0x prefix
        regexArray.append(regexPattern("\\b0[x][0-9A-Fa-f]+\\b", type: .number))  // regexArray.append(regexPattern("\\b0[xX][0-9A-Fa-f]+\\b", type: .number))
        
        self.regexPatterns = Set(regexArray.compactMap{$0})
        
        
        // IV: Setup Numeric Patterns
        var numericArray = [SyntaxPattern?]()
        // Number
        numericArray.append(regexPattern("(?<!-)(\\b[\\d|\\.]+)(\\b)", type: .number))
        // Pre-processor Attributes
        numericArray.append(regexPattern("#if\\b|#else\\b|#elseif\\b|#endif\\b|#if os\\|#elseif os\\b", type: .preprocessor))
        self.numericPatterns = Set(numericArray.compactMap{$0})
        
        
        // V: Setup String Patterns
        var stringArray = [SyntaxPattern?]()
        // Single-line string literal
        stringArray.append(regexPattern("(\"|@\")[^\"\\n]*(@\"|\")", type: .string))
        // Multi-line string literal
        stringArray.append(regexPattern("(\"\"\")(.*?)(\"\"\")", options: [.dotMatchesLineSeparators], type: .string))
        self.stringPatterns = Set(stringArray.compactMap{$0})
        
        
        // VI: Setup Comment Patterns
        var commentArray = [SyntaxPattern?]()
        // Line comment
        commentArray.append(regexPattern("//(.*)", type: .comment))
        // Block comment
        commentArray.append(regexPattern("(/\\*)(.*?)(\\*/)", options: [.dotMatchesLineSeparators], type: .comment))
        // URL
        //commentArray.append(regexPattern("(http(s)?:\\/\\/.)?(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)", type: .string))
        self.commentPatterns = Set(commentArray.compactMap{$0})
        
    }
    
}
