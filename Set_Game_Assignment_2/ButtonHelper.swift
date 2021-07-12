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
        case .grey:
            return UIColor.darkGray
        }
    }
    
    static func getShape(ofCard card: Card) -> String{
        switch card.shape {
        case .square:
            return "◼︎"
        case .circle:
            return "●"
        case .triangular:
            return "▲"
        }
    }
    
    private static func getCardText(ofCard card:Card, withShape shape: String) -> String {
        switch card.number {
        case .one:
            return "\(shape)"
        case .two:
            return "\(shape)   \(shape)"
        case .three:
            return "\(shape)   \(shape)   \(shape)"
        }
    }
    
    private static func getAttributesButton(ofCard card: Card, withColor color: UIColor, withText text: String) -> NSAttributedString {
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
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
    
    
    
    static func setAttributes(toButton button: UIButton, ofCard card: Card) {
        let color = getColor(ofCard: card)
        let shape = getShape(ofCard: card)
        let text = getCardText(ofCard: card, withShape: shape)
        let attributes = getAttributesButton(ofCard: card, withColor: color, withText: text)
        button.setAttributedTitle(attributes, for: UIControl.State.normal)
        
        
    }
    
    
}


