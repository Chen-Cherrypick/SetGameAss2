//
//  ButtonExtension.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 28/06/2021.
//

import Foundation
import UIKit

extension UIButton {
    
    func select(color: UIColor = #colorLiteral(red: 1, green: 0.9767686725, blue: 0.836220324, alpha: 1) ) {
        self.layer.borderWidth = 5.0
        self.layer.borderColor = color.cgColor
    }
    
    func deselect(color: UIColor = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
    }
    
}
