//
//  ButtonHelper.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 22/06/2021.
//

import Foundation
import UIKit

class ButtonHelper {
    
    
    private static func getColor(ofCard card: Card) -> UIColor {
        switch card.color {
        case .pink:
            return UIColor.systemPink
        case .purple:
            return UIColor.purple
        case .yellow:
            return UIColor.darkGray
        }
    }
    
    private static func getShape(ofCard card: Card) -> String{
        switch card.shape {
        case .square:
            return "◼︎"
        case .circle:
            return "●"
        case .triangular:
            return "▲"
        }
    }
    
    private static func getNumber(ofCard card:Card, withShape shape: String) -> String {
        switch card.number {
        case .one:
            return "\(shape)"
        case .two:
            return "\(shape) \(shape)"
        case .three:
            return "\(shape) \(shape) \(shape)"
        }
    }
    
    private static func getAttributesButton(ofCard card: Card, withColor color: UIColor, withNumber number: String) -> NSAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [:]
        switch card.shading {
        case .open:
            attributes[.foregroundColor] = color
            attributes[.strokeWidth] = 5
        case .stripped:
            attributes[.foregroundColor] = color.withAlphaComponent(0.15)
            attributes[.strokeWidth] = -1
        case .solid:
            attributes[.foregroundColor] = color
            attributes[.strokeWidth] = -1
        }
        return NSAttributedString(string: number, attributes: attributes)
    }
    
    
    
    
    
    static func getButtonSettings(toButton button: UIButton, ofCard card: Card) {
        let color = getColor(ofCard: card)
        let shape = getShape(ofCard: card)
        let number = getNumber(ofCard: card, withShape: shape)
        let attributes = getAttributesButton(ofCard: card, withColor: color, withNumber: number)
        button.setAttributedTitle(attributes, for: UIControl.State.normal)
        
        
    }
    
    
}

extension UIButton {
    
    func select(color: UIColor = #colorLiteral(red: 1, green: 0.9767686725, blue: 0.836220324, alpha: 1) ) {
        self.layer.borderWidth = 5.0
        self.layer.borderColor = color.cgColor
//        self.layer.backgroundColor = #colorLiteral(red: 1, green: 0.9767686725, blue: 0.836220324, alpha: 1)
    }
    
    func deselect(color: UIColor = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
//        self.layer.backgroundColor = color.cgColor
    }
    
    func selected() -> Bool {
        return self.layer.borderWidth == 5.0
    }
}
