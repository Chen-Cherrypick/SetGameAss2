//
//  SetGame.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 22/06/2021.
//

import Foundation

class SetGame{
    
    var score = 0
    var cardsDeck = [Card]()
    var cardsInGame = [Card]()
    var selectedCards = [Card]()
    
    
    
    private func generateCardsCombination() {
        for color in Color.values {
            for shape in Shape.values {
                for number in Number.values {
                    for shading in Shading.values {
                        let card = Card(color: color, shape: shape, number: number, shading: shading)
                        cardsDeck.append(card)
                    }
                }
            }
        }
    }
    
    
    func newGame() {
        score = 0
        cardsDeck.removeAll()
        cardsInGame.removeAll()
        selectedCards.removeAll()
        generateCardsCombination()
        addCards(numberOfCardsToAdd: 12)
        
    }
    
    func addThreeCards() {
        score -= 1
        addCards(numberOfCardsToAdd: 3)
    }
    
    private func addCards(numberOfCardsToAdd numOfCards: Int) {
        for _ in 0..<numOfCards {
            let indexOfCard = cardsDeck.count.arc4random
            let card = cardsDeck.remove(at: indexOfCard)
            cardsInGame.append(card)
        }
    }
    
    func selectCard(card: Card) {
        if selectedCards.count == 3 && isSet() {
            for card in selectedCards {
                if let cardIndex = cardsInGame.firstIndex(of: card) {
                    cardsInGame.remove(at: cardIndex)
                    if cardsDeck.count > 0 {
                        let randomIndex = cardsDeck.count.arc4random
                        let randomCard = cardsDeck.remove(at: randomIndex)
                        cardsInGame.insert(randomCard, at: cardIndex)
                    }
                }
                
            }
            score += 5
            selectedCards.removeAll()
        } else if selectedCards.count == 3 && !isSet() {
            score -= 5
            selectedCards.removeAll()
        }
        
        if selectedCards.count != 3 {
            if let selectedCard = selectedCards.firstIndex(of: card) {
                selectedCards.remove(at: selectedCard)
            } else {
                selectedCards.append(card)
            }
        }
        
    }
    
    
    func isSet() -> Bool {
        if selectedCards.count != 3 {
            return false
        }
        let checkColor = checkFeature(card1Prop: selectedCards[0].color.rawValue, card2Props: selectedCards[1].color.rawValue, card3Props: selectedCards[2].color.rawValue)
        let checkNumber = checkFeature(card1Prop: selectedCards[0].number.rawValue, card2Props: selectedCards[1].number.rawValue, card3Props: selectedCards[2].number.rawValue)
        let checkShape = checkFeature(card1Prop: selectedCards[0].shape.rawValue, card2Props: selectedCards[1].shape.rawValue, card3Props: selectedCards[2].shape.rawValue)
        let checkShading = checkFeature(card1Prop: selectedCards[0].shading.rawValue, card2Props: selectedCards[1].shading.rawValue, card3Props: selectedCards[2].shading.rawValue)
        return checkColor && checkNumber && checkShape && checkShading

    }
    
    func isSelected(card: Card) -> Bool {
        return selectedCards.firstIndex(of: card) != nil
    }
    
    
    private func checkFeature (card1Prop prop1: String, card2Props prop2: String, card3Props prop3: String) -> Bool {
        return ((prop1, prop2) == (prop2, prop3) ||
                ((prop1 != prop2) && (prop2 != prop3) && (prop3 != prop1)))
    }
    
}

extension Int {
    var arc4random: Int {
        if self>0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
