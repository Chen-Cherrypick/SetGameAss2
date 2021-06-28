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
    
    @IBOutlet weak var iphoneScoreLbl: UILabel!
    private var timerIphone : Timer?
    
    private var tempupdateEmojiTimerTimer : Timer?
    
    private let minimumLengthForIphoneTurn = 20.0
    
    private let maximumLengthForIphoneTurn = 40.0
    
    
    private let game = SetGame()
    
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        stopTimer()
        let date = Date()
        game.newGame(date: date)
        addThreeMoreCardsBtn.isEnabled = true
        hintBtn.isEnabled = true
        updateViewFromModel()
        startTimer()
        
        
    }
    
    private func startTimer() {
        iphoneScoreLbl.text = Emoji.thinkingMode
        let randomTime = Double.random(in: minimumLengthForIphoneTurn..<maximumLengthForIphoneTurn)
        tempupdateEmojiTimerTimer = Timer.scheduledTimer(timeInterval: randomTime-5, target: self, selector: #selector(changeEmojiBeforeIphoneTurn), userInfo: nil, repeats: false)
        timerIphone = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(iphoneTurn), userInfo: nil, repeats: false)
    }
    
    @objc private func changeEmojiBeforeIphoneTurn() {
        iphoneScoreLbl.text = Emoji.aboutToMakeAMoveMode
        updateViewFromModel()
    }
    
    @objc private func iphoneTurn() {
        self.game.getAPossibleSet(iphoneTurn: true)
        iphoneScoreLbl.text = Emoji.waitingMode
        updateViewFromModel()
    }
    
    private func stopTimer() {
        iphoneScoreLbl.text = Emoji.waitingMode
        tempupdateEmojiTimerTimer?.invalidate()
        timerIphone?.invalidate()
    }
    
    private func checkFinalScores() {
        if game.getIphoneScore() > self.game.getPlayerScore() {
            iphoneScoreLbl.text = Emoji.winningMode
        } else {
            iphoneScoreLbl.text = Emoji.losingMode
        }
    }
    
    
    @IBAction func add3Cards(_ sender: UIButton) {
        game.clearSelected()
        if (game.getCardsInGame().count > 0 && game.getCardsInGame().count <= 21){
            addThreeMoreCardsBtn.isEnabled = true
            game.addThreeCards()
            updateViewFromModel()
        }
        
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if game.getSelectedCards().count == 3 && game.isSelectionASet() {
            stopTimer()
            startTimer()
        }
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            if cardIndex < game.getCardsInGame().count {
                let card = game.getCardsInGame()[cardIndex]
                game.selectCard(card: card)
            }
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        var indexOfCard = 0
        scoreLabel.text = "Score: \(game.getPlayerScore())"
        if game.getCardsInGame().count == 0 && game.getIsStarted() {
            checkFinalScores()
            let alert = UIAlertController(title: "Alert", message: "Congrats! You Won!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            for card in game.getCardsInGame() {
                let cardButton = cardButtons[indexOfCard]
                cardButton.backgroundColor = Colors.pink
                ButtonHelper.setAttributes(toButton: cardButton, ofCard: card)
                changeButtonBorder(forButton: cardButton, ofCard: card)
                indexOfCard += 1
            }
            while indexOfCard < cardButtons.count {
                let button = cardButtons[indexOfCard]
                button.backgroundColor =  Colors.peach
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)
                let attributes = NSAttributedString(string: "")
                button.setAttributedTitle(attributes, for: UIControl.State.normal)
                indexOfCard += 1
            }
        }
        
    }
    
    func changeButtonBorder(forButton button: UIButton, ofCard card: Card) {
        if game.isCardSelected(card: card) {
            if game.getSelectedCards().count==3{
                if game.isSelectionASet() {
                    stopTimer()
                    button.select(color: Colors.green)
                } else {
                    button.select(color: Colors.red)
                }
            } else {
                button.select()
            }
        } else {
            button.deselect()
        }
        
    }
    
    @IBAction func getAHint(_ sender: UIButton) {
        if game.isSelectionASet() {
            game.clearSelected()
            startTimer()
        } else if game.findPossibleSetsInGame().count > 0 {
            game.getAPossibleSet(iphoneTurn: false)
            stopTimer()
        }
        updateViewFromModel()
        
    }
    
    
    
    
    struct Emoji {
        static let thinkingMode  = "🤔"
        static let aboutToMakeAMoveMode = "😄"
        static let winningMode = "😂"
        static let losingMode = "😢"
        static let waitingMode = "😶"
    }
    
    struct Colors {
        static let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let green = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        static let peach = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)
        static let pink = #colorLiteral(red: 1, green: 0.8976516128, blue: 0.8997941613, alpha: 1)
    }
    
    
}

