//
//  ColourPalette.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-11-03.
//

import SwiftUI

struct ColorPalette {
//    static let color1 = Color(hex: "edeec9")
//    static let color2 = Color(hex: "dde7c7")
//    static let color3 = Color(hex: "bfd8bd")
//    static let color4 = Color(hex: "98c9a3")
//    static let color5 = Color(hex: "77bfa3")
    static let color1 = Color(hex: "c9e4ca")
    static let color2 = Color(hex: "87bba2")
    static let color3 = Color(hex: "55828b")
    static let color4 = Color(hex: "3b6064")
    static let color5 = Color(hex: "364958")
}

// Extend Color to support hexadecimal color values
extension Color {
    init(hex: String) {
        // Ensure the hex string starts with '#' and has a valid length
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let start = cleanedHex.hasPrefix("#") ? cleanedHex.index(cleanedHex.startIndex, offsetBy: 1) : cleanedHex.startIndex
        
        let hexString = String(cleanedHex[start...])
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

