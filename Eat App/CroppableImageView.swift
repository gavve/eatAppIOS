//
//  CroppableImageView.swift
//  CropImg
//
//  Created by Duncan Champney on 3/24/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

//---------------------------------------------------------------------------------------------------------

func rectFromStartAndEnd(startPoint:CGPoint, endPoint: CGPoint, view: UIImage) -> CGRect
{
    var  top, left, bottom, right: CGFloat;
    top = min(startPoint.y, endPoint.y)
    bottom = max(startPoint.y, endPoint.y)
  
    left = min(startPoint.x, endPoint.x)
    right = max(startPoint.x, endPoint.x)
    
    var maxWidthHeight: CGFloat = 0.0
    
    if view.size.height > view.size.width {
        maxWidthHeight = view.size.width
        print("height > width")
    }
    if view.size.width > view.size.height {
        maxWidthHeight = view.size.height
        print("width > height")
    }
    
    let width = right-left
    let height = bottom-top
    var widthHeight: CGFloat = width
    
    if widthHeight > maxWidthHeight {
        widthHeight = maxWidthHeight
        print("widthHeight > maxWidth")
    }
    
    let result = CGRectMake(left, top, widthHeight, widthHeight)
    return result
}

//----------------------------------------------------------------------------------------------------------
class DragableImageView: UIImageView
{
    var dragStartPositionRelativeToCenter : CGPoint?
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        self.userInteractionEnabled = true   //< w00000t!!!1
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.Began {
            let locationInView = nizer.locationInView(superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            
            return
        }
        
        if nizer.state == UIGestureRecognizerState.Ended {
            dragStartPositionRelativeToCenter = nil
            
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            
            return
        }
        
        let locationInView = nizer.locationInView(superview)
        
        UIView.animateWithDuration(0.1) {
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
  }
