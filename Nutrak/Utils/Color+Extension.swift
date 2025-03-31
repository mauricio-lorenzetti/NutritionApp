//
//  Color+Extension.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    // MARK: - Brand Colors
    static let primary = Color(hex: "FFA726")
    static let secondary = Color(hex: "F1F1F1")
    static let accent = Color(hex: "66BB6A")
    static let black = Color(hex: "141414")
    static let white = Color(hex: "FFFFFF")
    
    
    // MARK: - Nutrition Colors
    static let proteins = Color.accent
    static let carbs = Color.primary
    static let fats = Color(hex: "6DA0FF")
    
    static let calories = Color(hex: "FF6D6A")
    
    // MARK: - UI Elements
    static let background = Color.white
    static let cardBackground = Color.secondary
    static let disabled = Color.secondary
}
