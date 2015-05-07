//
//  CanvasViewController.swift
//  021-Swift-Drawing-Pad
//
//  Created by Audrey Li on 5/4/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    var drawingToolBar: DrawingToolBar!
    
    
    var drawingData:DrawingData = DrawingData(lineWidth: 20, strokeAlpha: 0.9, strokeColor: UIColor.redColor(), palette: [UIColor(hex: "E91E63"), UIColor(hex: "2196F3"), UIColor(hex: "4CAF50"), UIColor(hex: "FFEB3B"), UIColor(hex: "FF9800"), UIColor(hex: "9C27B0")]) {
        didSet {
            if drawingToolBar != nil {
                drawingToolBar.frame = getDrawingToolBarFrame()
                drawingToolBar.drawingData = drawingData
            }
        }
    }

    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var lastPoint = CGPoint.zeroPoint
    var swiped = false
    
    var settingViewFrame: CGRect!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let isHorizental = APPConfig.isDrawingToolBarHorizental
        let itemWidth = APPConfig.drawingToolBarItemWidthHeight
        drawingData.maximuPaletteColors = Int(isHorizental ? (view.bounds.width / itemWidth) : (view.bounds.height / itemWidth)) - 3
        
        drawingToolBar = DrawingToolBar(frame: getDrawingToolBarFrame(), drawingData: drawingData)
        drawingToolBar.doneHandler = {self.didPressButton(data: $0, settingType: $1)}
        view.addSubview(drawingToolBar)
    }
    
    ////------- drawing related-------------
    @IBAction func reset(sender: AnyObject) {
        displayImageView.image = nil
    }
    
    @IBAction func share(sender: UIButton) {
        UIGraphicsBeginImageContext(displayImageView.bounds.size)
        displayImageView.image?.drawInRect(displayImageView.frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = sender
        presentViewController(activity, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      

        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self.view)
           
            //remove the previous settingViews if any
            if (settingViewFrame?.contains(lastPoint) != nil) {
                if let oldSettingView:SettingView = view.viewWithTag(APPConfig.settingViewTag) as? SettingView {
                    drawingData = oldSettingView.data
                    oldSettingView.removeFromSuperview()
                }
            }
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(view.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        drawingImageView.image?.drawInRect(view.frame)
        CGContextMoveToPoint(ctx, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(ctx, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, drawingData.lineWidth)
        let strokeColor = drawingData.isEraserMode ? UIColor.whiteColor() : drawingData.strokeColor
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor)
        CGContextSetBlendMode(ctx, kCGBlendModeNormal)
        
        CGContextStrokePath(ctx)
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        let strokeAlpha:CGFloat = drawingData.isEraserMode ? 1 : drawingData.strokeAlpha
        drawingImageView.alpha = strokeAlpha
        UIGraphicsEndImageContext()
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
        
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        // merge imageView into mainImageView
        UIGraphicsBeginImageContext(displayImageView.frame.size)
        displayImageView.image?.drawInRect(view.frame, blendMode: kCGBlendModeNormal, alpha: 1.0)
        let strokeAlpha:CGFloat = drawingData.isEraserMode ? 1 : drawingData.strokeAlpha
        drawingImageView.image?.drawInRect(view.frame, blendMode: kCGBlendModeNormal, alpha: strokeAlpha)
        displayImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        drawingImageView.image = nil
        
    }

    
    ////------- layouts and toolbar related -------------
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawingToolBar.frame = getDrawingToolBarFrame()
        
    }
    
    func didPressButton(#data: DrawingData, settingType: SettingType){
        drawingData = data
        //remove the previous settingViews if any 
        if let oldSettingView:SettingView = view.viewWithTag(APPConfig.settingViewTag) as? SettingView {
            drawingData = oldSettingView.data
            oldSettingView.removeFromSuperview()
        }
        
        if settingType == .Eraser {
            drawingData.isEraserMode = true
        } else {
            drawingData.isEraserMode = false
        }
        switch settingType {
        case .LineWidth:
            presentSettingView(.LineWidth)
        case .StrokeAlpha:
            presentSettingView(.StrokeAlpha)
        case .AddColor:
            presentColorPickerView()
        case .Eraser:
            drawingData.isEraserMode = true
        default: break
        }
    }
    
    func presentColorPickerView(){
        let settingViewRect = view.frame.insetSquare(dx: APPConfig.toolBarWidthPercentageByContainerView * view.frame.width)
        
        let colorPickerView = ColorPickerView(frame: view.bounds)
        colorPickerView.palette = drawingData.palette
        view.addSubview(colorPickerView)
        colorPickerView.doneHandler = { self.drawingData.palette = $0}
    }
    
    func presentSettingView(settingType: SettingType){
         settingViewFrame = view.frame.insetSquare(dx: APPConfig.drawingToolBarItemWidthHeight + APPConfig.toolBarToSettingViewDistance)
        var settingView: SettingView
        if settingType == .LineWidth {
            settingView = SettingView(frame: settingViewFrame, data: drawingData, settingType: .LineWidth)
        } else {
             settingView = SettingView(frame: settingViewFrame, data: drawingData, settingType: .StrokeAlpha)
        }
        view.addSubview(settingView)
        settingView.tag = APPConfig.settingViewTag
        settingView.doneHandler = { self.drawingData = $0 }
     

    }
    
    func getDrawingToolBarFrame() -> CGRect {
        let isHorizental = APPConfig.isDrawingToolBarHorizental
        let itemWidth = APPConfig.drawingToolBarItemWidthHeight
        
        let drawingToolBarItemsCount = drawingData.palette.count + 4 // plus lineWidth, strokeAlpha, eraser, addColor
        var rectWidth = isHorizental ? itemWidth * CGFloat(drawingToolBarItemsCount) : itemWidth
        var rectHeight = isHorizental ? itemWidth : itemWidth * CGFloat(drawingToolBarItemsCount)
        var padding = isHorizental ? (view.bounds.height - itemWidth) : (view.bounds.width - itemWidth)
        var drawingToolBarFrame: CGRect
        
        switch APPConfig.drawingToolBarPosition {
        case .leftCenter:
            drawingToolBarFrame = view.bounds.paddingRight(itemWidth).rectByCentering(rectWidth, height: rectHeight)
        case .rightCenter:
            drawingToolBarFrame = view.bounds.paddingLeft(itemWidth).rectByCentering(rectWidth, height: rectHeight)
        case .topCenter:
            drawingToolBarFrame = view.bounds.paddingBottom(itemWidth).rectByCentering(rectWidth, height: rectHeight)
        default:
            drawingToolBarFrame = view.bounds.paddingLeft(itemWidth).rectByCentering(rectWidth, height: rectHeight)
        }
        return drawingToolBarFrame
    }
}
