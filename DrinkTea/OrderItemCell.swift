//
//  OrderItemCell.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/28.
//

import UIKit

class OrderItemCell: UITableViewCell {

    @IBOutlet weak var ivDrinkThumb: UIImageView!
    @IBOutlet weak var lbDrinkName: UILabel!
    @IBOutlet weak var lbDrinkOptions: UILabel!
    @IBOutlet weak var lbOrdererName: UILabel!
    @IBOutlet weak var lbDrinkPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
