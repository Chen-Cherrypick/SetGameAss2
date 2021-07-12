//
//  Card.swift
//  assignment_1
//
//  Created by Chen Shoresh on 15/06/2021.
//

import Foundation


struct CardConcentration: Hashable {

    
    var hashValue: Int {return id}
    static func ==(lhs: CardConcentration, rhs: CardConcentration)-> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    private static var idCount = 0
    var isFaceUp = false
    var isMatched = false
    private var id : Int
    

    private static func makeUniqueId() -> Int {
        idCount += 1
        return idCount
    }
    
    init() {
        self.id = CardConcentration.makeUniqueId()
    }
}
