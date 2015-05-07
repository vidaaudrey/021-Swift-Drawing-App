//
//  SettingView.swift
//  021-Swift-Drawing-Pad
//
//  Created by Audrey Li on 5/5/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit



class SettingView: UIView {
    var data: DrawingData! {
        didSet{
            if data != nil && previewImageView != nil {
                drawPreview()
            }
        }
    }
    var previewImageView: UIImageView!
    var settingType: SettingType!
    var doneHandler: ((data: DrawingData) -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame: CGRect, data: DrawingData, settingType: SettingType){
        super.init(frame: frame)
        self.data = data
        self.settingType = settingType
        
        switch settingType{
        case .LineWidth, .StrokeAlpha:
            showSliderAndPreview(settingType)
        default: break
            
        }
    }
    
    
    func showSliderAndPreview(settingType: SettingType) {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        previewImageView = UIImageView(frame: bounds.rectByInsetBottom(0.3 * bounds.height))
        addSubview(previewImageView)
        drawPreview()
        
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "sliderAndPreviewdoubleTapped:")
        tapRec.numberOfTapsRequired = 2
        addGestureRecognizer(tapRec)
        
        switch settingType{
            case .LineWidth :
                addSliderView(data.lineWidth / bounds.width)
            case .StrokeAlpha:
                addSliderView(data.strokeAlpha)
            default: break
        }

    }
    
    func addSliderView(value: CGFloat){
        let sliderFrame = bounds.rectByInsetTop(0.7 * bounds.height)
        let slider = UISlider(frame:sliderFrame)
        slider.value = Float(value)
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        addSubview(slider)
    }
    
    func sliderValueChanged(sender: UISlider){
        let newValue = CGFloat(sender.value)
        switch settingType! {
            case .LineWidth:
                data.lineWidth = newValue * frame.width // some random number is not right, update later
            case .StrokeAlpha:
                data.strokeAlpha = newValue
            default: break

        }
        drawPreview()
    }

    
    func drawPreview() {
        UIGraphicsBeginImageContext(previewImageView.frame.size)
        let centerPoint =  previewImageView.frame.center
        var ctx = UIGraphicsGetCurrentContext()
    
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, data.lineWidth)
        CGContextSetStrokeColorWithColor(ctx, data.strokeColor.CGColor)
        CGContextMoveToPoint(ctx,centerPoint.x, centerPoint.y)
        CGContextAddLineToPoint(ctx, centerPoint.x, centerPoint.y)
        CGContextStrokePath(ctx)
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        previewImageView.alpha = data.strokeAlpha
        UIGraphicsEndImageContext()

    }

    func sliderAndPreviewdoubleTapped(sender: UITapGestureRecognizer) {
        doneHandler?(data: data)
        self.removeFromSuperview()
        
    }
}
