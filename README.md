## Syntax Text Editor  

Swift syntax highlighting model based on TextKit/NSTextStorage.

Compatible with macOS and iOS (Cocoa, UIKit and SwiftUI).

![screenshot](https://raw.github.com/joey-gm/SyntaxTextEditor/master/Screenshot.png)

**Syntax Model:**
- Lexer (protocol) converts coding language keywords/regex into Syntax Patterns (struct) - a combination of patterns matching substring/regex, syntax type, and style in form of [NSAttributedString.Key], which will be used to generate matching tokens ( NSAttributedString.Key + NSRange ) for NSTextStorage to process
- Color, font and line spacing are customizable via Syntax Theme
- Supports Swift syntax (SwiftLexer). Can be extended for other programming languages

**Syntax Views:**
- SyntaxViewController for Cocoa and UIKit
- SyntaxUIViewRepresentable for SwiftUI (iOS)
- SyntaxNSViewRepresentable for SwiftUI (macOS)

**Examples:**
- Document based text editor for macOS / iOS across Cocoa, UIKit and SwiftUI.

---
Credits:
- twostraws - [Sourceful](https://github.com/twostraws/Sourceful)
