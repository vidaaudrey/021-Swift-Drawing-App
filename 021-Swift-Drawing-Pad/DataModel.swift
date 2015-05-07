//
//  DataModel.swift
//  
//
//  Created by Audrey Li on 5/5/15.
//
//

import Foundation
import UIKit

struct ToolBarData {
    var settingType: SettingType  // UIImage, UIColor, String ("alpha", "lineWidth"), CGFloat...
    var isSelected = false
    var value:AnyObject!  //could be value of slider, switch, color, or anything. Default is nil
    init(settingType: SettingType, isSelected: Bool = false, value:AnyObject? = nil){
        self.settingType = settingType
        self.isSelected = isSelected
        self.value = value
    }
}

struct DrawingData{
    var lineWidth: CGFloat
    var strokeAlpha: CGFloat
    var strokeColor: UIColor
    var fillColor: UIColor
    var isEraserMode = false
    var palette:[UIColor] = [] {
        didSet {
            if palette.count > maximuPaletteColors {
                for i in 0..<(palette.count - maximuPaletteColors){
                    palette.removeAtIndex(0)
                }
            }
        }
    }
    var maximuPaletteColors:Int = 4
    
    init(lineWidth: CGFloat, strokeAlpha: CGFloat, strokeColor: UIColor, fillColor: UIColor = UIColor.whiteColor(), palette:[UIColor] = []){
        self.lineWidth = lineWidth
        self.strokeAlpha = strokeAlpha
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.palette.append(strokeColor)
        if palette.count > 0 {
            for i in 0..<palette.count {
                self.palette.append(palette[i])
            }
        }
    }
}
enum SettingType: String{
    case LineWidth = "LineWidth"
    case StrokeAlpha = "StrokeAlpha"
    case StrokeColor = "StrokeColor"
    case FillColor = "FillColor"
    case AddColor = "AddColor"
    case PaletteColor = "PaletteColor"
    case Eraser = "Eraser"
}