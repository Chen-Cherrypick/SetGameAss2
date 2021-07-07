//
//  SetGame.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 22/06/2021.
//

import Foundation

class SetGame {
    
    
    private var scores = [Int](repeating: 0, count: 3)
    
    private var cardsDeck = [Card]()
    private var cardsInGame = [Card]()
    private var selectedCards = [Card]()
    
    private var hintWasApplay = false
    
    private var lastSavedDate = Date()
    
    private var isGameStarted = false
    
    
    private func initializeNewDeck() {
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
        scores = [Int](repeating: 0, count: 3)
        cardsDeck.removeAll()
        cardsInGame.removeAll()
        selectedCards.removeAll()
        initializeNewDeck()
        addCards(numberOfCardsToAdd: 12)
        self.lastSavedDate = date
        isGameStarted = true
    }
    
    func addThreeCards(by player: Int) {
        if(cardsDeck.count>2) {
            addCards(numberOfCardsToAdd: 3)
            scores[player] -= ScoreAdditions.addThreeCardsPoints
        }
        
    }
    
    private func addCards(numberOfCardsToAdd numOfCards: Int) {
        for _ in 0..<numOfCards {
            let indexOfCard = cardsDeck.count.arc4random
            let card = cardsDeck.remove(at: indexOfCard)
            cardsInGame.append(card)
        }
    }
    
    func updateScoreAccordingToTime(for playerNumber: Int) {
        if !hintWasApplay{
            let currentDate = Date()
            let diffInSeconds = currentDate.timeIntervalSince(lastSavedDate)
            if diffInSeconds > ScoreAdditions.stoper {
                scores[playerNumber] += ScoreAdditions.setAfterStoper
            } else {
                scores[playerNumber] += ScoreAdditions.setBeforeStoper
            }
            lastSavedDate = currentDate
        } else {
            hintWasApplay = false
        }

    }
    
    private func isCardSelecedTwice(card: Card) -> Bool {
        if selectedCards.count < 3, let indexCard = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: indexCard)
            return true
        } else {
            return false
        }
    }
    
    private func replaceCards() {
        for card in selectedCards {
            if let cardIndex = cardsInGame.firstIndex(of: card) {
                cardsInGame.remove(at: cardIndex)
                if cardsInGame.count < 12 && cardsDeck.count > 0 {
                    let randomIndex = cardsDeck.count.arc4random
                    let randomCard = cardsDeck.remove(at: randomIndex)
                    cardsInGame.insert(randomCard, at: cardIndex)
                    
                }
            }
            
        }
    }
    
    
    func selectCard(card: Card, by playerNumber: Int, for theFirstTime: Bool) {
        if !isCardSelecedTwice(card: card) {
            if selectedCards.count == 3 {
                if isSelectionASet() {
                    replaceCards()
                    updateScoreAccordingToTime(for: playerNumber)
                    selectedCards.removeAll()
                } else {
                    if theFirstTime {
                        scores[playerNumber] -= ScoreAdditions.wrongSet
                    }
                    selectedCards.removeAll()
            }
            
            } else if selectedCards.count != 3 {
                selectedCards.append(card)
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
    
    func isCardSelected(card: Card) -> Bool {
        return selectedCards.firstIndex(of: card) != nil
    }
    

    
    
    private func checkFeature (card1Prop prop1: String, card2Props prop2: String, card3Props prop3: String) -> Bool {
        return ((prop1, prop2) == (prop2, prop3) ||
                ((prop1 != prop2) && (prop2 != prop3) && (prop3 != prop1)))
    }
    

    
    func getAHint(forPlayer player: Int) {
        hintWasApplay = true
        let possibleSet = findPossibleSetsInGame()
        if possibleSet.count > 0 {
            scores[player] += ScoreAdditions.hintPoints
            selectedCards.removeAll()
            for card in possibleSet {
                selectedCards.append(card)
            }
        }
    }
    
    func shuffleCardsOnBoard() {
        cardsInGame.shuffle()
    }
    

    
    
    func findPossibleSetsInGame() -> [Card] {
        var cards = [Card]()
        for index1 in 0..<cardsInGame.count {
            for index2 in index1+1..<cardsInGame.count {
                for index3 in index2..<cardsInGame.count {
                     cards = [cardsInGame[index1], cardsInGame[index2], cardsInGame[index3]]
                    if isSet(threeCards: cards) {
                        return cards
                    }
                }
            }
        }
        return cards
    }
    
    
    func clearSelected() {
        replaceCards()
        selectedCards.removeAll()
    }
    
    func clearSelectedWrongSet() {
        selectedCards.removeAll()
    }
    

    func getPlayer1Score() -> Int {
        return scores[1]
    }
    
    func getPlayer2Score() -> Int {
        return scores[2]
    }


    func getIsStarted() -> Bool {
        return isGameStarted
    }
    
    func getCardsInGame() -> [Card] {
        return cardsInGame
    }
    
    func getSelectedCards() -> [Card] {
        return selectedCards
    }
    
    func isCardInGame(card: Card) -> Bool {
        return (cardsInGame.firstIndex(of: card) != nil)
    }
    
    func changeScoreForPlayerDidntPlayInHisTurn(player playerNumber: Int) {
        scores[playerNumber] -= ScoreAdditions.wrongSet
    }

    
    struct ScoreAdditions {
        static let stoper = 40.0
        static let setBeforeStoper = 7
        static let setAfterStoper = 3
        static let wrongSet = 5
        static let iphonePoint = 5
        static let addThreeCardsPoints = 3
        static let hintPoints = 1
    }
    
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
