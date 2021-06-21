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


enum Color {
    case pink
    case peach
    case yellow
    
    static let values = [pink, peach, yellow]
}

enum Shape {
    case square
    case circle
    case triangular
    
    static let values = [square, circle, triangular]
}


enum Number {
    case one
    case two
    case three
    
    static let values = [one, two, three]
}

enum Shading {
    case solid
    case stripped
    case open
    
    static let values = [solid, stripped, open]
}


