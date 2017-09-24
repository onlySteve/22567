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
    
    static func identifier() -> (String) {
        let className = self.nameOfClass
        
        return BusinessModel.shared.applicationState == .patient ? "\(className)Patient" : className
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let fontSize = CGFloat(BusinessModel.shared.applicationState == .patient ? 15.0 : 13.0)
        
        priceLabel.font = RegularFontWithSize(size: fontSize)
        sizeLabel.font = RegularFontWithSize(size: fontSize)
        titleLabel.font = RegularFontWithSize(size: fontSize)
    }
    
    func config(with trade: TradeStruct) {
        
        if BusinessModel.shared.applicationState == .patient {
            titleLabel.text = trade.manuf
            sizeLabel.text = String(format: "%@ %@ %@",
                                    trade.title,
                                    trade.strength,
                                    trade.form)
        } else {
            let title = String(format: "%@ %@ %@\n(%@)",
                               trade.title,
                               trade.strength,
                               trade.form,
                               trade.manuf)
            
            titleLabel.text = "\(title)  "
            priceLabel.text = trade.price
            sizeLabel.text = trade.size
        }
    }
}
