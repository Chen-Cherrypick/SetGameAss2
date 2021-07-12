//
//  ViewController.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 21/06/2021.
//

import UIKit

class SetGameViewController: UIViewController {
    
    @IBOutlet weak var addThreeMoreCardsBtn: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scoreLabelPlayer1: UILabel!
    
    @IBOutlet weak var whosTurnLabel: UILabel!
    
    @IBOutlet weak var scoreLabelPlayer2: UILabel!
    
    @IBOutlet weak var hintBtn: UIButton!
    
    @IBOutlet weak var player2Btn: UIButton!
    
    @IBOutlet weak var player1Btn: UIButton!
    
    private let timeForFirstTry = 10
    
    private let timeForSecondTry = 15
    
    private let game = SetGame()
    
    static var playerTurn = Int()
    
    private var timer : Timer?
    
    private var firstTurn = true
    
    private var cardsAvailables = false
    
    private var wrongSet = false
    
    private  var timeForTurn = 10 {
        didSet {
            if SetGameViewController.playerTurn != 0 {
                timerLabel.text = String(timeForTurn)
            } else {
                timerLabel.text = "0"
            }
            
        }
    }
    
    
    
    
    
    @IBOutlet weak var cardsGrid: BoardView! {
        didSet {
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(add3Cards))
            swipe.direction = [.up]
            cardsGrid.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            cardsGrid.addGestureRecognizer(rotate)
            
        }
        
    }
    
    
    
    private func startTimer(with time: Int) {
        cardsAvailables = true
        if time == timeForFirstTry {
            timeForTurn = timeForFirstTry
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchPlayerTurn), userInfo: nil, repeats: true)
        } else {
            if !wrongSet {
                game.changeScoreForPlayerDidntPlayInHisTurn(player: SetGameViewController.playerTurn)
            }
//            game.changeScoreForPlayerDidntPlayInHisTurn(player: SetGameViewController.playerTurn)
            changePlayerNumber()
            timeForTurn = time
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(noOnesTurn), userInfo: nil, repeats: true)
            updateViewFromModel()
            
            
        }
        
    }
    
    
    private func stopTimer() {
        timer?.invalidate()
        timeForTurn = 0
        addThreeMoreCardsBtn.isEnabled = false
        hintBtn.isEnabled = false
        
    }
    
    
    @objc private func switchPlayerTurn() {
        if timeForTurn > 0 {
            timeForTurn -= 1
        } else if timeForTurn == 0 {
            game.clearSelectedWrongSet()
            firstTurn = false
            timer?.invalidate()
            startTimer(with: 15)
            addThreeMoreCardsBtn.isEnabled = false
            
        }
        
    }
    
    @objc private func noOnesTurn() {
        if timeForTurn > 0 {
            timeForTurn -= 1
        } else if timeForTurn == 0 {
            let alert = UIAlertController(title: "Alert", message: "You both suck", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: clearSelected))
            self.present(alert, animated: true, completion: nil)
            timer?.invalidate()
            SetGameViewController.playerTurn = 0
            timeForTurn = 0
            addThreeMoreCardsBtn.isEnabled = false
            hintBtn.isEnabled = false
            player2Btn.isEnabled = true
            player1Btn.isEnabled = true
            cardsAvailables = false
            
        }
    }
    
    private func clearSelected(alert: UIAlertAction) {
        game.clearSelectedWrongSet()
        wrongSet = false
        updateViewFromModel()
    }
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        SetGameViewController.playerTurn = 0
        let date = Date()
        game.newGame(date: date)
        hintBtn.isEnabled = false
        addThreeMoreCardsBtn.isEnabled = false
        player2Btn.isEnabled = true
        player1Btn.isEnabled = true
        cardsGrid.cardViews.removeAll()
        updateViewFromModel()
    }
    
    @objc func shuffleCards() {
        game.shuffleCardsOnBoard()
        updateViewFromModel()
    }
    
    
    private func checkFinalScores() -> Int{
        if game.getPlayer2Score() > self.game.getPlayer1Score() {
            return 2
        } else {
            return 1
        }
    }
    
    private func changePlayerNumber() {
        if SetGameViewController.playerTurn == 1 {
            SetGameViewController.playerTurn = 2
        } else {
            SetGameViewController.playerTurn = 1
        }
    }
    
    @IBAction func add3Cards(_ sender: UIButton?) {
        if SetGameViewController.playerTurn != 0 {
            if game.isSelectionASet() {
                game.clearSelected()
            } else {
                game.clearSelectedWrongSet()
            }
            if (game.getCardsInGame().count < 79){
                addThreeMoreCardsBtn.isEnabled = true
                hintBtn.isEnabled = true
                game.addThreeCards(by: SetGameViewController.playerTurn)
                updateViewFromModel()
            }
            updateViewFromModel()
        }
    }
    
    
    private func updateTurnLabel() {
        if SetGameViewController.playerTurn == 1 {
            whosTurnLabel.text = "⬅️"
        } else if SetGameViewController.playerTurn == 2 {
            whosTurnLabel.text = "➡️"
        } else {
            whosTurnLabel.text = "❓"
        }
    }
    
    private func updateViewFromModel() {
        scoreLabelPlayer1.text = "Score Player 1: \(game.getPlayer1Score())"
        scoreLabelPlayer2.text = "Score Player 2: \(game.getPlayer2Score())"
        updateTurnLabel()
        if game.getCardsInGame().count == 0 && game.getIsStarted() {
            let winner = checkFinalScores()
            let alert = UIAlertController(title: "Alert", message: "Congrats! Player \(winner) is the winner!", preferredStyle: UIAlertController.Style.alert)
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
    
    private func updateTurns() {
        if game.getSelectedCards().count == 3 {
            stopTimer()
            if !game.isSelectionASet(){
                if firstTurn {
                    firstTurn = false
                    wrongSet = true
                    startTimer(with: timeForSecondTry)
                } else {
                    wrongSet = true
                    noOnesTurn()
                }
            } else {
                cardsAvailables = false
                SetGameViewController.playerTurn = 0
                player2Btn.isEnabled = true
                player1Btn.isEnabled = true
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
        if cardsAvailables {
            let oldPlayer = SetGameViewController.playerTurn
            let oldFirstTurn = firstTurn
            updateTurns()
            switch recognizer.state {
            case .ended:
                if let cardView = recognizer.view! as? CardView {
                    let index = cardsGrid.cardViews.firstIndex(of: cardView) ?? 0
                    let card = game.getCardsInGame()[index]
                    game.selectCard(card: card, by: oldPlayer,for: oldFirstTurn)
                }
            default:
                break
            }
            updateViewFromModel()
        } else if game.getSelectedCards().count > 0 {
            game.clearSelectedWrongSet()
        }
    }
    
    private func playerStarted() {
        startTimer(with: timeForFirstTry)
        addThreeMoreCardsBtn.isEnabled = true
        hintBtn.isEnabled = true
        player1Btn.isEnabled = false
        player2Btn.isEnabled = false
    }
    
    @IBAction func player1Turn(_ sender: UIButton) {
        firstTurn = true
        SetGameViewController.playerTurn = 1
        playerStarted()
        updateViewFromModel()
        
    }
    
    @IBAction func player2Turn(_ sender: UIButton) {
        firstTurn = true
        SetGameViewController.playerTurn = 2
        playerStarted()
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
            game.getAHint(forPlayer: SetGameViewController.playerTurn)
        }
        stopTimer()
        updateViewFromModel()
    }
    
    
    
    
}

