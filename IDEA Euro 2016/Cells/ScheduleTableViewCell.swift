//
//  ScheduleTableViewCell.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/31/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var teamALogo: UIImageView!
    @IBOutlet weak var teamBLogo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tvsLabel: UILabel!
    @IBOutlet weak var goalTeamALabel: UILabel!
    @IBOutlet weak var goalTeamBLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
