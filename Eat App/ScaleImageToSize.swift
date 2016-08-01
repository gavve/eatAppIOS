//
//  ScaleImageToSize.swift
//  Eat App
//
//  Created by vmware on 28/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation
import UIKit


func getFramedImage(let image: UIImage) -> UIImage {
    
    let screenSize = UIScreen.mainScreen().bounds.size // hamtar skarmstorlek
    
    let newPic = CGRectMake(0.0, 0.0, image.size.width, image.size.width)
    let diffHigh = newPic.size.height - image.size.height
    let background1 = CGRectMake(0.0, 0.0, image.size.width, diffHigh/2.0)    
    
    
    UIGraphicsBeginImageContextWithOptions(newPic.size, false, UIScreen.mainScreen().scale)
    UIColor.blackColor().setFill()
    UIRectFill(newPic)
    
    var pic = CGRectMake(CGFloat(0.0), CGFloat(diffHigh/2.0), image.size.width, image.size.height)
    
    image.drawInRect(pic)
    let resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage
    
    
}

func mergeImages(background: UIImage, forground: UIImage, size:CGSize) {

    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    //image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
}

func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
    let hasAlpha = false
    // Automatically use scale factor of main screen
    let scale: CGFloat = 0.0
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
}