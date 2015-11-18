//
//  RankTableViewCell.swift
//  ColorSpeed
//
//  Created by Eddie on 11/17/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet var userSticker: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
