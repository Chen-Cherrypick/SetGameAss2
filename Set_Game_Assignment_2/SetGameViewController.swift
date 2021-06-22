//
//  ViewController.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 21/06/2021.
//

import UIKit

class SetGameViewController: UIViewController {
    
    @IBOutlet weak var addCardsBtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    let game = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        game.newGame()
        addCardsBtn.isEnabled = true
        updateViewFromModel()
    }
   
    @IBAction func add3Cards(_ sender: UIButton) {
        if (game.cardsInGame.count > 0){
            game.addThreeCards()
            updateViewFromModel()
            if game.cardsInGame.count > 23 {
                addCardsBtn.isEnabled = false
            }
        }
   
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            if cardIndex < game.cardsInGame.count {
                let card = game.cardsInGame[cardIndex]
                game.selectCard(card: card)
            }
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        var indexOfCard = 0
        scoreLabel.text = "Score: \(game.score)"
        for card in game.cardsInGame {
            let cardButton = cardButtons[indexOfCard]
            cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.8976516128, blue: 0.8997941613, alpha: 1)
            ButtonHelper.getButtonSettings(toButton: cardButton, ofCard: card)
            changeButtonBorder(forButton: cardButton, ofCard: card)
            indexOfCard += 1
        }
        while indexOfCard < cardButtons.count {
            let button = cardButtons[indexOfCard]
            button.backgroundColor =  #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)
            let attributes = NSAttributedString(string: "")
            button.setAttributedTitle(attributes, for: UIControl.State.normal)
            indexOfCard += 1
        }
    }
    
    func changeButtonBorder(forButton button: UIButton, ofCard card: Card) {
        if game.isSelected(card: card) {
            if game.selectedCards.count==3 && game.isSet() {
                button.select(color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            } else if game.selectedCards.count != 3{
                button.select()
            } else if game.selectedCards.count==3 && !game.isSet() {
                button.select(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            }
        } else {
            button.deselect()
        }
        
    }
    
    
    
}

