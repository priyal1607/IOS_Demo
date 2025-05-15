//
//  UIView+Extensions.swift
//  IosDemo
//
//  Created by priyal on 15/05/25.
//

import UIKit
import SwiftUI

extension UIView {
   
    
    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
  
}
