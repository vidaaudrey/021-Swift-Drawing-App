//
//  DrawingToolBar.swift
//  021-Swift-Drawing-Pad
//
//  Created by Audrey Li on 5/6/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class DrawingToolBar: UIView {
    var drawingData:DrawingData!{
        didSet{
            if drawingData != nil {
                layoutToolBar(bounds)
            }
        }
    }
    var doneHandler: ((drawingData: DrawingData, settingType: SettingType) -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init (frame: CGRect,drawingData: DrawingData) {
        super.init(frame: frame)
        backgroundColor = APPConfig.drawingToolBarBackgroundColor
        self.drawingData = drawingData
        layoutToolBar(bounds)
    }
    
    func layoutToolBar(rect: CGRect){
        // clean up before redraw
        let views = self.subviews
        for i in 0..<views.count {
            if views[i] is UIButton {
                views[i].removeFromSuperview()
            }
        }
        
        let dataItemCount = drawingData.palette.count + 4  // plus lineWidth, strokeAlpha, eraser, addColor
        let strokeColorIndex:Int = (drawingData.palette.indexOf(drawingData.strokeColor) ?? 0) + 3
        var itemWidth: CGFloat
        var itemHeight: CGFloat
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        let isHorizentalToolBar = APPConfig.isDrawingToolBarHorizental
        
        if isHorizentalToolBar {
            itemWidth = rect.width / CGFloat(dataItemCount)
            itemHeight = rect.height
        } else {
            itemWidth = rect.width
            itemHeight = rect.height / CGFloat(dataItemCount)
        }
        
        let originalItemFrame = CGRectMake(offsetX * itemWidth, offsetY * itemHeight, itemWidth, itemHeight)
        
        for i in 0..<dataItemCount {
            let btnFrame = originalItemFrame.rectByShift(shiftX: isHorizentalToolBar ? itemWidth * CGFloat(i) : 0 , shiftY:  isHorizentalToolBar ? 0 : itemHeight * CGFloat(i))
            let btn = UIButton.buttonWithType(.System) as! UIButton
            btn.frame = btnFrame.insetMaxSquare()
            btn.tag = i

            switch i {
                // lineWidth
            case 0:
                btn.setBackgroundImage(StyleKit.imageOfLineWidth(frame: btn.bounds), forState: .Normal)
                // strokeAlpha
            case 1:
                 btn.setBackgroundImage(StyleKit.imageOfStrokeAlpha(frame: btn.bounds), forState: .Normal)
                // eraser
            case 2:
                btn.setBackgroundImage(StyleKit.imageOfEraser(frame: btn.bounds), forState: .Normal)
                //strokeColor (selectedColor)
            case strokeColorIndex:
                btn.roundWithBorder(fillColor: drawingData.strokeColor, borderColor: APPConfig.drawingToolBarRoundItemBorderColor, borderWidth: APPConfig.drawingToolBarRoundItemLineWidth)
                // add new color
            case dataItemCount - 1:
                btn.setBackgroundImage(StyleKit.imageOfAddColor(frame: btn.bounds), forState: .Normal)
                btn.round(inset: APPConfig.drawingToolBarRoundItemInset)
            default:
                btn.backgroundColor = drawingData.palette[i-3]
                btn.round(inset: APPConfig.drawingToolBarRoundItemInset)
            }
            
            btn.addTarget(self, action: "btnPressed:", forControlEvents: .TouchUpInside)
            
            addSubview(btn)
        }
        
    }
    
    func btnPressed(sender: UIButton){
        let index = sender.tag
        switch index {
        case 0:
             doneHandler?(drawingData: drawingData, settingType:.LineWidth)
        case 1:
             doneHandler?(drawingData: drawingData, settingType:.StrokeAlpha)
        case 2:
            doneHandler?(drawingData: drawingData, settingType:.Eraser)
        case drawingData.palette.count + 3:
             doneHandler?(drawingData: drawingData, settingType:.AddColor)
        default:
            drawingData.strokeColor = drawingData.palette[index - 3]
            doneHandler?(drawingData: drawingData, settingType:.PaletteColor)
        }
       
    }

}
