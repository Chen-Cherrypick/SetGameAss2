//
//  BoardView.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 30/06/2021.
//

import UIKit

class BoardView: UIView {
    
    
    var cardViews = [CardView]() {
        didSet {
            addsubViews(); setNeedsLayout()
        }
        willSet {
            removeSubviews()
        }
    }
    
    private func addsubViews() {
        for card in cardViews {
            addSubview(card)
        }
    }
    
    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(0.7), frame: bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                let index = row * grid.dimensions.columnCount + column
                if cardViews.count > index {
                    cardViews[index].frame = grid[row,column]!.insetBy(dx: 3.0, dy: 3.0)
                }
            }
        }
    }
    

    override func draw(_ rect: CGRect) {

    }


}
