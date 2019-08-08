//
//  NoteView.swift
//  TextViewLine
//
//  Created by Muhammad Luqman on 1/1/18.
//  Copyright © 2018 Muhammad Luqman. All rights reserved.
//

import UIKit

class NoteView: UITextView, UITextViewDelegate {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    convenience init() {
        
        let frame:CGRect = CGRect.zero
        self.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
                
        let lineHight = Float((font?.lineHeight)!)
        
        let tempHig = Float(contentSize.height + bounds.size.height)
        //Get the current drawing context
        let context: CGContext = UIGraphicsGetCurrentContext()!
        //Set the line color and width
        context.setStrokeColor(UIColor(red: CGFloat(Float(93.0/255.0)), green: CGFloat(Float(0.0/255)), blue: CGFloat(Float(85.0/255.0)), alpha: 0.80).cgColor)
        
        context.setLineWidth(0.50)
        //Start a new Path
        context.beginPath()
        //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
        let numberOfLines = Int((tempHig/lineHight))
        //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
        let baselineOffset: Float = 6.0
        
        for x in 1..<numberOfLines {
            
            let y = (Float(lineHight * Float(x)) + 0.5 + baselineOffset)
            context.move(to: CGPoint(x: bounds.origin.x, y: CGFloat(y)))
            context.addLine(to: CGPoint(x: bounds.size.width, y: CGFloat(y)))
        }
        //Close our Path and Stroke (draw) it
        context.closePath()
        context.strokePath()
    }
}
