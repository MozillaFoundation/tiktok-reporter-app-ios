//
//  Font+Extension.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

// MARK: - Helpers

private enum FontVariations: Int {
    case weight = 2003265652
    case width = 2003072104
    case opticalSize = 1869640570
}

extension Font {

    // MARK: - App Fonts

    static var heading1: Font {
        return .custom("ZillaSlab-Regular", size: 36.0)
    }
    
    static var heading2: Font {
        return .custom("ZillaSlab-Light", size: 28.0)
    }
    
    static var heading3: Font {
        return .custom("ZillaSlab-Regular", size: 24.0)
    }
    
    static var heading4: Font {
        return .custom("ZillaSlab-Regular", size: 22.0)
    }
    
    static var heading5: Font {
        return .custom("ZillaSlab-Bold", size: 20.0)
    }
    
    static var heading6: Font {
        return .custom("ZillaSlab-Regular", size: 12.0)
    }
    
    static var body1: Font {
        return .variableFont(18.0, axes: [FontVariations.weight.rawValue: 400])
    }

    static var body2: Font {
        return .variableFont(14.0, axes: [FontVariations.weight.rawValue: 400])
    }

    static var body3: Font {
        return .variableFont(18.0, axes: [FontVariations.weight.rawValue: 600])
    }

    // MARK: - Helper Methods

    private static func variableFont(_ size: CGFloat, axes: [Int: Int] = [:]) -> Font {
        let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: "Nunito Sans", kCTFontVariationAttribute as UIFontDescriptor.AttributeName: axes])
        let newUIFont = UIFont(descriptor: uiFontDescriptor, size: size)
        
        return Font(newUIFont)
    }
}
