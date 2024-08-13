//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    static let colors: [String: String] = [
        "OlveDrab": "#6B8E23",
        "ForestGreen": "#228B22",
        "Brown": "#A52A2A",
        "Khaki": "#F0E68C"
    ]

    static func color(named name: String) -> UIColor? {
        guard let hexCode = colors[name] else { return nil }
        return UIColor(hexCode: hexCode)
    }

    static var olveDrab: UIColor { return color(named: "OlveDrab")! }
    static var forestGreen: UIColor { return color(named: "ForestGreen")! }
    static var brown: UIColor { return color(named: "Brown")! }
    static var khaki: UIColor { return color(named: "Khaki")! }
}
