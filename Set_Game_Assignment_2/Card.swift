//
//  Card.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 21/06/2021.
//

import Foundation

struct Card: Equatable {
    
    
    let color : Color
    let shape : Shape
    let number : Number
    let shading : Shading
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.shape == rhs.shape
            && lhs.number == rhs.number && lhs.shading == rhs.shading
    }
}


enum Color: String {
    case pink
    case purple
    case grey
    
    static let values = [pink, purple, grey]
}

enum Shape: String {
    case square
    case circle
    case triangular
    
    static let values = [square, circle, triangular]
}


enum Number: String {
    case one
    case two
    case three
    
    static let values = [one, two, three]
}

enum Shading: String {
    case solid
    case stripped
    case open
    
    static let values = [solid, stripped, open]
}


