//
//  TradeTableViewCell.swift
//  BugWise
//
//  Created by olbu on 6/18/17.
//  Copyright © 2017 olbu. All rights reserved.
//

class TradeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.font = RegularFontWithSize(size: 13)
        sizeLabel.font = RegularFontWithSize(size: 13)
        titleLabel.font = RegularFontWithSize(size: 13)
    }
    
    func config(with trade: TradeStruct) {
        titleLabel.text = "\(trade.title)  " 
        priceLabel.text = trade.price
        sizeLabel.text = trade.size
    }
    
}
