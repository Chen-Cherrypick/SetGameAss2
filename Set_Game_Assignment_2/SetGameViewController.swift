//
//  ViewController.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 21/06/2021.
//

import UIKit

class SetGameViewController: UIViewController {
    
    @IBOutlet weak var addThreeMoreCardsBtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var hintBtn: UIButton!
    

    private let game = SetGame()
    
    
    @IBOutlet weak var cardsGrid: BoardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(add3Cards))
            swipe.direction = [.up]
            cardsGrid.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            cardsGrid.addGestureRecognizer(rotate)
            
        }
        
    }
    

    
    @IBAction func newGameBtn(_ sender: UIButton) {
        let date = Date()
        game.newGame(date: date)
        addThreeMoreCardsBtn.isEnabled = true
        hintBtn.isEnabled = true
        cardsGrid.cardViews.removeAll()
        updateViewFromModel()
        
        
    }
    
    @objc func shuffleCards() {
        game.shuffleCardsOnBoard()
        updateViewFromModel()
    }
    


    
//    private func checkFinalScores() {
//        if game.getIphoneScore() > self.game.getPlayerScore() {
//            iphoneScoreLbl.text = Emoji.winningMode
//        } else {
//            iphoneScoreLbl.text = Emoji.losingMode
//        }
//    }
    
    
    @IBAction func add3Cards(_ sender: UIButton?) {
        game.clearSelected()
        if (game.getCardsInGame().count < 81){
            addThreeMoreCardsBtn.isEnabled = true
            game.addThreeCards()
            updateViewFromModel()
        }
        
    }
    
    
    
    
    private func updateViewFromModel() {
//        var indexOfCard = 0
        scoreLabel.text = "Score: \(game.getPlayerScore())"
        if game.getCardsInGame().count == 0 && game.getIsStarted() {
            let alert = UIAlertController(title: "Alert", message: "Congrats! You Won!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            updateCardsViewsFromModel()
        }
        
    }
    
    
    private func updateCardsViewsFromModel() {
        if cardsGrid.cardViews.count - game.getCardsInGame().count > 0 {
            let cardsView = cardsGrid.cardViews[..<game.getCardsInGame().count]
            cardsGrid.cardViews = Array(cardsView)
        }
        
        let numberOfCardsView = cardsGrid.cardViews.count
        for index in game.getCardsInGame().indices {
            let card = game.getCardsInGame()[index]
            if index > (numberOfCardsView-1) {
                let cardView = CardView()
                updateCardView(forCardView: cardView, forCard: card)
                addTapGestureRecognizerToCardView(for: cardView)
                cardsGrid.cardViews.append(cardView)
            } else {
                let cardView = cardsGrid.cardViews[index]
                updateCardView(forCardView: cardView, forCard: card)
            }
            
            
        }
    }
    
    private func addTapGestureRecognizerToCardView(for cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(by:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc private func tapCard(by recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? CardView {
                let index = cardsGrid.cardViews.firstIndex(of: cardView) ?? 0
                let card = game.getCardsInGame()[index]
                game.selectCard(card: card)
            }
        default:
            break
        }
        updateViewFromModel()
    }
    
    
    private func updateCardView(forCardView cardView: CardView, forCard card: Card) {
        cardView.shape = ButtonHelper.getShape(ofCard: card)
        cardView.color = card.color.rawValue
        cardView.shading = card.shading.rawValue
        cardView.number = card.number.rawValue
        cardView.isSelected = game.isCardSelected(card: card)
        let isSet = game.isSelectionASet()
        if isSet {
            if game.isCardSelected(card: card) {
                cardView.isMatched = isSet
            } else {
                cardView.isMatched = nil
            }
        } else if game.getSelectedCards().count == 3 && game.isCardSelected(card: card) {
            cardView.isMatched = false
        } else {
            cardView.isMatched = nil
        }

    }
    
    
    
    @IBAction func getAHint(_ sender: UIButton) {
        if game.isSelectionASet() {
            game.clearSelected()
        } else if game.findPossibleSetsInGame().count > 0 {
            game.getAHint()
        }
        updateViewFromModel()
        
    }
    
    
    
    
}

