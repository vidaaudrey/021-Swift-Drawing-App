//
//  ViewController.swift
//  021-Swift-Drawing-Pad
//
//  Created by Audrey Li on 5/2/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var alpha: CGFloat = 1.0
    var swiped = false
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]
    var currentPencilTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pencilPressed(sender: UIButton) {
        
        view.viewWithTag(currentPencilTag)?.transform = CGAffineTransformIdentity
        currentPencilTag = sender.tag
        
        sender.transform = CGAffineTransformMakeTranslation(0, -20)
        
        var index = sender.tag ?? 0
        if index < 0 || index  >= colors.count {
            index = 0
        }
        (red, green, blue) = colors[index]
        
        // eraser, white color
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    @IBAction func reset(sender: AnyObject) {
        mainImageView.image = nil
    }

    @IBAction func share(sender: UIButton) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(mainImageView.frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = sender
        presentViewController(activity, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue

    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(view.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        imageView.image?.drawInRect(view.frame)
        CGContextMoveToPoint(ctx, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(ctx, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, brushWidth)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1)
        CGContextSetBlendMode(ctx, kCGBlendModeNormal)
        
        CGContextStrokePath(ctx)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
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
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(view.frame, blendMode: kCGBlendModeNormal, alpha: 1.0)
        imageView.image?.drawInRect(view.frame, blendMode: kCGBlendModeNormal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.image = nil
        
    }
}

extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
}

