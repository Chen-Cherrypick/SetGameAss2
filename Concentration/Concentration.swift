//
//  Concentration.swift
//  assignment_1
//
//  Created by Chen Shoresh on 15/06/2021.
//

import Foundation

class Concentration {
    
    private(set) var cards = [CardConcentration]()
    
    private var indexOfOneCardFaceUp : Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set (newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    
    var score = 0
    
    var seenCards = [CardConcentration]()
    
    
    func checkIfTwoCardsMatched(card1 index1: Int, newCard index2: Int) {
        if cards[index1] == cards[index2] {
            cards[index1].isMatched = true;
            cards[index2].isMatched = true;
            score+=2
        } else {
            if (!seenCards.contains(cards[index2])) {
                seenCards.append(cards[index2])
            } else {
                score -= 1
            }
            if (!seenCards.contains(cards[index1])) {
                seenCards.append(cards[index1])
            } else {
                score -= 1
            }
        }
        cards[index2].isFaceUp = true
    }
    
    

    func chooseCard (at index: Int) {
        assert(cards.indices.contains(index),"concentration.chooeCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneCardFaceUp , matchIndex != index{
                checkIfTwoCardsMatched(card1: matchIndex, newCard: index)
            } else if cards[index].isFaceUp && cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly != nil {
                cards[index].isFaceUp = false
            } else {
                for flipIndex in cards.indices{
                    cards[flipIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfOneCardFaceUp = index
            }
            flipCount+=1
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards>0,"concentration.init(nunmberOfPairs: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = CardConcentration()
            cards += [card,card]
        }
        cards.shuffle()
    }
    
}


extension Collection {
    var oneAndOnly : Element? {
    return count == 1 ? first : nil
    }
}
