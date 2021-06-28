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
    var notInUseCards = [Card]()
    
    var possibleSet = [[Card]]()
    
    var date = Date()
    
    var iphoneScore = 0
    
    var isIphoneTurn = false
    
    var isStarted = false
    
    
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
    
    
    func newGame(date: Date) {
        score = 0
        iphoneScore = 0
        cardsDeck.removeAll()
        cardsInGame.removeAll()
        selectedCards.removeAll()
        generateCardsCombination()
        addCards(numberOfCardsToAdd: 12)
        findPossibleSetsInGame()
        self.date = date
        isStarted = true
    }
    
    func addThreeCards() {
        if(possibleSet.count>0){
            score -= 3
        }
        addCards(numberOfCardsToAdd: 3)
    }
    
    private func addCards(numberOfCardsToAdd numOfCards: Int) {
        for _ in 0..<numOfCards {
            let indexOfCard = cardsDeck.count.arc4random
            let card = cardsDeck.remove(at: indexOfCard)
            cardsInGame.append(card)
        }
    }
    
    private func checkTiming() {
        let currentDate = Date()
        let diffInSeconds = currentDate.timeIntervalSince(date)
        if diffInSeconds > 60 {
            score += 3
        } else {
            score += 7
        }
        date = currentDate
    }
    
    private func isCardSelecedTwice(card: Card) -> Bool {
        if let indexCard = selectedCards.firstIndex(of: card) , selectedCards.count < 3{
            selectedCards.remove(at: indexCard)
            return true
        } else {
            return false
        }
    }
    
    
    func selectCard(card: Card) {
        if !isCardSelecedTwice(card: card) {
            if selectedCards.count == 3 && isSelectionASet() {
                for cardS in selectedCards {
                    if let cardIndex = cardsInGame.firstIndex(of: cardS) {
                        notInUseCards.append(cardS)
                        cardsInGame.remove(at: cardIndex)
                        if cardsInGame.count < 12 && cardsDeck.count > 0 {
                            let randomIndex = cardsDeck.count.arc4random
                            let randomCard = cardsDeck.remove(at: randomIndex)
                            cardsInGame.insert(randomCard, at: cardIndex)
                            
                        }
                    }
                    
                }
                findPossibleSetsInGame()
                if !isIphoneTurn{
                    checkTiming()
                }
                isIphoneTurn = false
                selectedCards.removeAll()
            } else if selectedCards.count == 3 && !isSelectionASet() {
                score -= 5
                selectedCards.removeAll()
            } else if selectedCards.count != 3 {
                if let selectedCard = selectedCards.firstIndex(of: card), let _ = notInUseCards.firstIndex(of: card){
                    selectedCards.remove(at: selectedCard)
                } else {
                    selectedCards.append(card)
                }
            }
        }
        
        
    }
    
    
    func isSet(threeCards cards: [Card]) -> Bool {
        if cards.count != 3 {
            return false
        }
        let checkColor = checkFeature(card1Prop: cards[0].color.rawValue, card2Props: cards[1].color.rawValue, card3Props: cards[2].color.rawValue)
        let checkNumber = checkFeature(card1Prop: cards[0].number.rawValue, card2Props: cards[1].number.rawValue, card3Props: cards[2].number.rawValue)
        let checkShape = checkFeature(card1Prop: cards[0].shape.rawValue, card2Props: cards[1].shape.rawValue, card3Props: cards[2].shape.rawValue)
        let checkShading = checkFeature(card1Prop: cards[0].shading.rawValue, card2Props: cards[1].shading.rawValue, card3Props: cards[2].shading.rawValue)
        return checkColor && checkNumber && checkShape && checkShading
    }
    
    func isSelectionASet() -> Bool {
        return isSet(threeCards: selectedCards)
    }
    
    func isSelected(card: Card) -> Bool {
        return selectedCards.firstIndex(of: card) != nil
    }
    
    
    private func checkFeature (card1Prop prop1: String, card2Props prop2: String, card3Props prop3: String) -> Bool {
        return ((prop1, prop2) == (prop2, prop3) ||
                ((prop1 != prop2) && (prop2 != prop3) && (prop3 != prop1)))
    }
    
    func getHint() {
        if possibleSet.count > 0 {
            score += 3
            selectedCards.removeAll()
            let cards = possibleSet[0]
            for card in cards {
                selectedCards.append(card)
            }
            possibleSet.remove(at: 0)
        }

    }
    
    func iphoneTurn() {
        if possibleSet.count > 0 {
            iphoneScore += 5
            selectedCards.removeAll()
            let cards = possibleSet[0]
            for card in cards {
                selectedCards.append(card)
            }
            possibleSet.remove(at: 0)
            findPossibleSetsInGame()
            isIphoneTurn = true
        }
    }
    
    
    private func findPossibleSetsInGame() {
        possibleSet.removeAll()
        for index1 in 0..<cardsInGame.count {
            for index2 in index1+1..<cardsInGame.count {
                for index3 in index2..<cardsInGame.count {
                    let cards = [cardsInGame[index1], cardsInGame[index2], cardsInGame[index3]]
                    if isSet(threeCards: cards) {
                        possibleSet.append(cards)
                    }
                }
            }
        }

    }
    
    
    func clearSelected() {
        for cardS in selectedCards {
            if let cardIndex = cardsInGame.firstIndex(of: cardS) {
                notInUseCards.append(cardS)
                cardsInGame.remove(at: cardIndex)
                if cardsInGame.count < 12 && cardsDeck.count > 0 {
                    let randomIndex = cardsDeck.count.arc4random
                    let randomCard = cardsDeck.remove(at: randomIndex)
                    cardsInGame.insert(randomCard, at: cardIndex)
                    
                }
            }
            
        }
        findPossibleSetsInGame()
        isIphoneTurn = false
        selectedCards.removeAll()
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
