//
//  DefaultThemes.swift
//  SyntaxTextEditor
//
//  Created by Joey
//

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif


struct DarkTheme: SyntaxTheme {
    
    let font: Font
    
    let lineHeightMultiple: CGFloat = 1.5
    
    let backgroundColor = #colorLiteral(red: 0.1607838571, green: 0.1647063792, blue: 0.1882354319, alpha: 1)
    
    func color(for type: SyntaxType) -> Color {
        switch type {
        case .plain:        return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.85)
        case .number:       return #colorLiteral(red: 0.8515872955, green: 0.7879342437, blue: 0.4857068062, alpha: 1)
        case .string:       return #colorLiteral(red: 0.9962008595, green: 0.5062164664, blue: 0.4404479265, alpha: 1)
        case .keyword:      return #colorLiteral(red: 0.9999999404, green: 0.4784311652, blue: 0.6980392933, alpha: 1)
        case .comment:      return #colorLiteral(red: 0.4980396628, green: 0.5490192771, blue: 0.5960788131, alpha: 1)
        case .markup:       return #colorLiteral(red: 0.6380758286, green: 0.6931763291, blue: 0.7475357652, alpha: 1)
        case .preprocessor: return #colorLiteral(red: 1, green: 0.6313727498, blue: 0.3098036945, alpha: 1)
        case .url:          return #colorLiteral(red: 0.3999997973, green: 0.5999999046, blue: 0.9999995828, alpha: 1)
        case .declaration:  return #colorLiteral(red: 0.4196076989, green: 0.8745101094, blue: 0.9999999404, alpha: 1)
        case .declaration2: return #colorLiteral(red: 0.3069577813, green: 0.6911872625, blue: 0.7984338403, alpha: 1)
        case .identifier:   return #colorLiteral(red: 0.8539165854, green: 0.7309650779, blue: 1, alpha: 1)
        case .identifier2:  return #colorLiteral(red: 0.6980389953, green: 0.5058825612, blue: 0.9215682745, alpha: 1)
        case .identifier3:  return #colorLiteral(red: 0.6727539897, green: 0.9499083161, blue: 0.8928622603, alpha: 1)
        case .identifier4:  return #colorLiteral(red: 0.4690371752, green: 0.761286974, blue: 0.7028915286, alpha: 1)
        }
    }
    
    init() {
        #if os(macOS)
        if #available(macOS 10.15, *) {
            self.font = Font.monospacedSystemFont(ofSize: 11, weight: .regular)
        } else {
            self.font = Font(name: "Menlo", size: 11)!
        }
        #elseif os(iOS)
        if #available(iOS 9.0, *) {
            self.font = Font.monospacedSystemFont(ofSize: 20, weight: .regular)
        } else {
            self.font = Font(name: "Menlo", size: 20)!
        }
        #endif
    }
    
}


struct LightTheme: SyntaxTheme {
    
    let font: Font
    
    let lineHeightMultiple: CGFloat = 1.5
    
    let backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    
    func color(for type: SyntaxType) -> Color {
        switch type {
        case .plain:        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.85)
        case .number:       return #colorLiteral(red: 0.1524781883, green: 0.1627834439, blue: 0.8469621539, alpha: 1)
        case .string:       return #colorLiteral(red: 0.8210209012, green: 0.1831269264, blue: 0.1060942188, alpha: 1)
        case .keyword:      return #colorLiteral(red: 0.6784316897, green: 0.2392154336, blue: 0.643137455, alpha: 1)
        case .comment:      return #colorLiteral(red: 0.4392161965, green: 0.4980389476, blue: 0.5490201712, alpha: 1)
        case .markup:       return #colorLiteral(red: 0.3609528542, green: 0.408539772, blue: 0.452252686, alpha: 1)
        case .preprocessor: return #colorLiteral(red: 0.4705886245, green: 0.2862742245, blue: 0.164706409, alpha: 1)
        case .url:          return #colorLiteral(red: 0.07602777332, green: 0.2145501077, blue: 1, alpha: 1)
        case .declaration:  return #colorLiteral(red: 0.008975126781, green: 0.3865099549, blue: 0.5487995744, alpha: 1)
        case .declaration2: return #colorLiteral(red: 0.01974069886, green: 0.48775208, blue: 0.6895507574, alpha: 1)
        case .identifier:   return #colorLiteral(red: 0.2938959599, green: 0.1305164397, blue: 0.690191865, alpha: 1)
        case .identifier2:  return #colorLiteral(red: 0.5019603372, green: 0.3098039329, blue: 0.7215684056, alpha: 1)
        case .identifier3:  return #colorLiteral(red: 0.1372550428, green: 0.3411768675, blue: 0.360784471, alpha: 1)
        case .identifier4:  return #colorLiteral(red: 0.2431369722, green: 0.501960814, blue: 0.5294116139, alpha: 1)
        }
    }
    
    init() {
        #if os(macOS)
        if #available(macOS 10.15, *) {
            self.font = Font.monospacedSystemFont(ofSize: 11, weight: .regular)
        } else {
            self.font = Font(name: "Menlo", size: 11)!
        }
        #elseif os(iOS)
        if #available(iOS 12.0, *) {
            self.font = Font.monospacedSystemFont(ofSize: 20, weight: .regular)
        } else {
            self.font = Font(name: "Menlo", size: 20)!
        }
        #endif
    }
    
}
