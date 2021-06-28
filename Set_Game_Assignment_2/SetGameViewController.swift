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
    
    @IBOutlet weak var hintBtn: UIButton!
    
    @IBOutlet weak var iphoneScoreLbl: UILabel!
    var timerIphone : Timer?
    
    var tempTimer : Timer?
    

    
    let game = SetGame()
    var iphoneMode = true
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        stopTimer()
        let date = Date()
        game.newGame(date: date)
        addCardsBtn.isEnabled = true
        hintBtn.isEnabled = true
        updateViewFromModel()
        startTimer()
        
        
    }
    
    private func startTimer() {
        iphoneScoreLbl.text = "🤔"
        let randomTime = Double.random(in: 20..<40)
        tempTimer = Timer.scheduledTimer(timeInterval: randomTime-5, target: self, selector: #selector(changeEmojiBeforeIphoneTurn), userInfo: nil, repeats: false)
        timerIphone = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(iphoneTurn), userInfo: nil, repeats: false)
    }
    
    @objc private func changeEmojiBeforeIphoneTurn() {
        iphoneScoreLbl.text = "😄"
        updateViewFromModel()
    }
    
    @objc private func iphoneTurn() {
        self.game.iphoneTurn()
        iphoneScoreLbl.text = "😶"
        updateViewFromModel()
    }
    
    private func stopTimer() {
        iphoneScoreLbl.text = "😶"
        tempTimer?.invalidate()
        timerIphone?.invalidate()
    }
    
    private func checkScores() {
        if game.iphoneScore > self.game.score {
            iphoneScoreLbl.text = "😂"
        } else {
            iphoneScoreLbl.text = "😢"
        }
    }
    
   
    @IBAction func add3Cards(_ sender: UIButton) {
        game.clearSelected()
        if (game.cardsInGame.count > 0 && game.cardsInGame.count <= 21){
            addCardsBtn.isEnabled = true
            game.addThreeCards()
            updateViewFromModel()
        } else {
            addCardsBtn.isEnabled = false
        }
   
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if game.selectedCards.count==3 && game.isSelectionASet() {
            stopTimer()
            startTimer()
        }
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
        if game.cardsInGame.count == 0 && game.isStarted {
            checkScores()
            let alert = UIAlertController(title: "Alert", message: "Congrats! You Won!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
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
       
    }
    
    func changeButtonBorder(forButton button: UIButton, ofCard card: Card) {
        if game.isSelected(card: card) {
            if game.selectedCards.count==3 && game.isSelectionASet() {
                button.select(color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            } else if game.selectedCards.count != 3{
                button.select()
            } else if game.selectedCards.count==3 && !game.isSelectionASet() {
                button.select(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            }
        } else {
            button.deselect()
        }
        
    }
    
    @IBAction func getAHint(_ sender: UIButton) {
        if game.isSelectionASet() {
            game.clearSelected()
            startTimer()
        } else if game.possibleSet.count > 0 {
            game.getHint()
            stopTimer()
        }
        updateViewFromModel()

    }
    
    
}

