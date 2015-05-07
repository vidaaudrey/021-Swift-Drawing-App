//
//  ColorPickerView.swift
//  021-Swift-Drawing-Pad
//
//  Created by Audrey Li on 5/5/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
    var view: UIView!

    @IBOutlet weak var paletteImageView: UIImageView!
    @IBOutlet weak var colorGridImageView: UIImageView!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var hexTextField: UITextField!
    
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!

    
    let gridWidth:CGFloat = APPConfig.colorPickerColorsSingleRectWidth
    var palette: [UIColor] = [] {
        didSet {
            if palette.count > 0 {
                palette = palette.unique()
                drawPalette()
            }

        }
    }
    
    var doneHandler:((palette: [UIColor]) -> Void)?

    
    var hue:CGFloat! {
        didSet {
            updatePreviewAndTextFields()
        }
    }
    var saturation: CGFloat!{
        didSet {
            updatePreviewAndTextFields()
        }
    }
    var brightness: CGFloat!{
        didSet {
            updatePreviewAndTextFields()
        }
    }
    
    func updatePreviewAndTextFields(){
        if hue != nil && saturation != nil && brightness != nil {
            let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
            preview.backgroundColor = newColor
            hexTextField.text = "#" + newColor.hexValue
 
//             let hsbaValues = newColor.hsbaValues
//            hueSlider.value = Float(hsbaValues.0)
//            saturationSlider.value = Float(hsbaValues.1)
//            brightnessSlider.value = Float(hsbaValues.2)
//            
//            let hueString = String(format: "%.2f", hueSlider.value * 360)
//            let saturationString = String(format: "%.2f", saturationSlider.value)
//            let brightnessString = String(format: "%.2f", brightnessSlider.value)
           
//            hueTextField.text = hueString
//            saturationTextField.text = saturationString
//            brightnessTextFied.text = brightnessString
//            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
        drawColorGrid()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    

    
    
    
    @IBAction func addColorBtnPressed(sender: UIButton) {
        palette.append(preview.backgroundColor!)
        
    }
    
    @IBAction func hueSliderValueChanged(sender: UISlider) {
        hue = CGFloat(sender.value)
    }
    
    @IBAction func saturationSliderValueChanged(sender: UISlider) {
        saturation = CGFloat(sender.value)
    }
    @IBAction func brightnessSliderValueChanged(sender: UISlider) {
         brightness = CGFloat(sender.value)
    }
    
    
    @IBAction func textFieldEditingEnded(sender: UITextField) {
        let hexString = sender.text
        if hexString.length == 6 || hexString.length == 7 {
            let previewColorHsba = UIColor(hex: hexString).hsbaValues
            hue = previewColorHsba.0
            saturation = previewColorHsba.1
            brightness = previewColorHsba.2
        }
    }
   
    

     // choose current preview color
    @IBAction func colorGridTappedOnce(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(colorGridImageView)
        let color = colorGridImageView.layer.getPixelColorAtPoint(point)
        updateHsbaValuesByColor(color)
        
    }
    // add color to palette
    @IBAction func colorGridTappedTwice(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(colorGridImageView)
        let color = colorGridImageView.layer.getPixelColorAtPoint(point)
        palette.append(color)
    }
    
      // choose current preview color
    @IBAction func paletteTappedOnce(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(paletteImageView)
        let color = paletteImageView.layer.getPixelColorAtPoint(point)
        updateHsbaValuesByColor(color)

    }
    // delete color from palette
    @IBAction func paletteTappedThreeTimes(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(paletteImageView)
        let color = paletteImageView.layer.getPixelColorAtPoint(point)
        // rule out the touch point between gaps
        if color != UIColor.whiteColor() {
            palette.remove(color)
        }
        
    }
    // add to palette
    @IBAction func previewTappedTwice(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(preview)
        let color = preview.layer.getPixelColorAtPoint(point)
        palette.append(color)
    }
    
    
    // drawing functions
    func drawPalette(){
        UIGraphicsBeginImageContext(paletteImageView.frame.size)
        var ctx = UIGraphicsGetCurrentContext()
        let gridWidth = APPConfig.colorPickerPaletteSingleRectWidth
        let maximumDisplayColors = Int(paletteImageView.bounds.width / (gridWidth + APPConfig.colorPickerPaletteSingleRectPadding))
        
        // if there are too many colors, remove the olddest
        if palette.count > maximumDisplayColors {
            for i in 0..<(palette.count - maximumDisplayColors) {
                palette.removeAtIndex(0)
            }
        }
        
        var offsetX:CGFloat = 0
        let firstGridRect = CGRectMake(0, 0, gridWidth, gridWidth)
        println(firstGridRect)
        for var i = 0; i < palette.count; i++ {
            CGContextAddRect(ctx, firstGridRect.rectByShift(shiftX: offsetX))
            println(firstGridRect.rectByShift(shiftX: offsetX))
            palette[i].set()
            CGContextFillPath(ctx)
            offsetX += gridWidth + APPConfig.colorPickerPaletteSingleRectPadding
        }
        paletteImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        println(UIGraphicsGetImageFromCurrentImageContext().size)
        UIGraphicsEndImageContext()
        
    }
    func drawColorGrid(){
        UIGraphicsBeginImageContext(colorGridImageView.bounds.size)
        var ctx = UIGraphicsGetCurrentContext()
        let columns = colorGridImageView.bounds.width / gridWidth
        let rows =  colorGridImageView.bounds.height / gridWidth
        var offsetX: CGFloat = 0
        var offsetY:CGFloat = 0
        let firstGridRect = CGRectMake(0, 0, gridWidth, gridWidth)
        for var r = 0; r < Int(rows) + 1; r++ {
            offsetX = 0
            for var c = 1; c < Int(columns) + 1; c++ {
                CGContextAddRect(ctx, firstGridRect.rectByShift(shiftX: offsetX, shiftY: offsetY))
                
                // display black-white at first row
                if r == 0 {
                    UIColor(hue: 0, saturation: 0, brightness: CGFloat(c) / columns, alpha: 1).set()
                } else {
                    UIColor(hue: CGFloat(c) / columns, saturation: CGFloat(r) / rows, brightness: 1, alpha: 1).set()
                }
                
                CGContextFillPath(ctx)
                offsetX += gridWidth
            }
            offsetY += gridWidth
        }
        colorGridImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    

    @IBAction func closeBtnPressed(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.layer.position = CGPointMake(self.frame.width / 2, self.frame.height * 1.5)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                self.doneHandler?(palette: self.palette)
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        hexTextField.resignFirstResponder()
    }
    
    func updateHsbaValuesByColor(color: UIColor){
        let hsba = color.hsbaValues
        hue = hsba.0
        saturation = hsba.1
        brightness = hsba.2
    }

}
