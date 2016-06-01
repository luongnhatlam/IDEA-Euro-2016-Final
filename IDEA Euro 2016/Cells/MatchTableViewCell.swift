//
//  MatchTableViewCell.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 6/1/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var teamALogo: UIImageView!
    @IBOutlet weak var teamBLogo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tvsLabel: UILabel!
    @IBOutlet weak var goalTeamALabel: UILabel!
    @IBOutlet weak var goalTeamBLabel: UILabel!
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var teamBLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithMatch(matches: [Match], indexPath: NSIndexPath) {
        
        let match = matches[indexPath.row]
        if let logoA = UIImage(named: "\(match.teamA)") {
            self.teamALogo.image = logoA
        } else {
            self.teamALogo.image = UIImage(named: "logo")
        }
        if let logoB = UIImage(named: "\(match.teamB)") {
            self.teamBLogo.image = logoB
        }else {
            self.teamBLogo.image = UIImage(named: "logo")
        }
        
        
        self.dateLabel.text = String.showFormatTime(match.date)
        self.goalTeamALabel.text = "\(match.goalsTeamA)"
        self.goalTeamBLabel.text = "\(match.goalsTeamB)"
        self.tvsLabel.text = match.tvs
        self.teamALabel.text = match.teamA
        self.teamBLabel.text = match.teamB
    }
    
}
