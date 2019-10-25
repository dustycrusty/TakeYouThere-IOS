//
//  Extensions.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 9..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    func mainBackgroundColor_Dark() -> UIColor{
        return UIColor(hexString: "4A4A4A")
    }
    
    func mainBackgroundColor_Light() -> UIColor{
        return UIColor(hexString: "D8D8D8")
    }
}
extension Date{
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = df.string(from: self)
        return stringDate
    }
}

extension String{
    func toDate() -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let date = df.date(from: self)
        return date!
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
extension UINavigationItem{
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = ""
    }
    
}
