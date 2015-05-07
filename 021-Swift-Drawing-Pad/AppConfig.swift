//
//  AppConfig.swift
//  020-Color-Play
//
//  Created by Audrey Li on 5/1/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit

public struct APPConfig {
    public static let toolBarWidthPercentageByContainerView: CGFloat = 0.1
    public static let toolBarHeightPercentageByContainerView: CGFloat = 0.1
    
    public static let isDrawingToolBarHorizental = false
    public static let drawingToolBarItemWidthHeight:CGFloat = 50
    public static let drawingToolBarPosition: Position = .leftCenter
    public static let settingViewTag = 100
    
    public static let colorPickerColorsSingleRectWidth: CGFloat = 20 // 44 is ideal, but not enought space to display
    public static let colorPickerPaletteSingleRectWidth: CGFloat = 44
    public static let colorPickerPaletteSingleRectPadding: CGFloat = 5
  
    //just for styling, not important 
    public static let drawingToolBarBackgroundColor = UIColor(hex: "#E0E0E0")
    public static let drawingToolBarRoundItemInset:CGFloat = 6
    public static let drawingToolBarRoundItemLineWidth:CGFloat = 4
    public static let drawingToolBarRoundItemBorderColor = UIColor(hex: "BDBDBD")
    public static let toolBarToSettingViewDistance: CGFloat = 20
    
     
}
