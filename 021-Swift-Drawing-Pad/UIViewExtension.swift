//
//  UIViewExtension.swift
//  017-Beautiful-ID-Photo
//
//  Created by Audrey Li on 4/16/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
  
    public func addGradientBackground(topColor: UIColor = UIColor.redColor(), bottomColor: UIColor = UIColor.greenColor()){
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    public func round(inset: CGFloat = 0 ) {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalInRect: bounds.rectByCentering(width, height: width).rectByInsetting(dx: inset, dy: inset)).CGPath
        self.layer.mask = mask
    }
    public func roundWithBorder(fillColor: UIColor = UIColor.clearColor(), borderColor:UIColor = UIColor.whiteColor(), borderWidth:CGFloat = 4) {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let centerSquare = bounds.rectByCentering(width, height: width)
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalInRect:centerSquare).CGPath

        self.layer.mask = mask
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(ovalInRect: centerSquare.rectByInsetting(dx: borderWidth, dy: borderWidth)).CGPath
        borderLayer.strokeColor = borderColor.CGColor
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = fillColor.CGColor
        self.layer.addSublayer(borderLayer)
    }
    
    public func centerInsideView(targetView: UIView) {
        let dx = (targetView.frame.size.width - frame.size.width)/2
        let dy = (targetView.frame.size.height - frame.size.height)/2
        frame = CGRectInset(targetView.frame, dx, dy)
    }
    
    public func addDashedBorder(color: UIColor, lineWidth: CGFloat) {
    
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4,4]  // the number is the same to prevent overlap in horizental or vertical mode
        shapeLayer.path = UIBezierPath(rect: shapeRect).CGPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    // -> clean context up later
    public func takeUIViewScreenShot() -> UIImage {
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func takeUIViewScreenShotInRect(frame: CGRect) -> UIImage {
        println("before screenshot\(frame)")
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width * scale, frame.size.height * scale), false, scale)
        let context = UIGraphicsGetCurrentContext()
 
        CGContextClipToRect(context, frame)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
