//
//  UIImageExtension.swift
//  CRM C
//
//  Created by guhan-pt6208 on 07/04/23.
//

import UIKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
