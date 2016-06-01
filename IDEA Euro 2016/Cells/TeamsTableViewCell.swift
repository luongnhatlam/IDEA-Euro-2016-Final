//
//  TeamsTableViewCell.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/30/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit

class TeamsTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithTeam(team: Team) {
        let banner:UIImage = UIImage(named: "Banner-\(team.name)")!
        self.bannerImageView.image = banner
        
        let logo:UIImage = UIImage(named: "\(team.name)")!
        self.flagImageView.image = logo
        
        self.countryLabel.text = team.name
        self.pointLabel.text = "Điểm: \(team.point)"
    }

}
