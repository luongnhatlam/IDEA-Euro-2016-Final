//
//  TeamsViewController.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/30/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit
import Firebase

class TeamsViewController: UIViewController {
    
    var database:FIRDatabaseReference!
    var dataList:[[String:[Team]]] = [[String:[Team]]]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.database = FIRDatabase.database().reference()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
    }
    
    
    
    func loadData() {
        self.database.child("Groups").queryOrderedByKey().observeEventType(.Value,withBlock: { (snap) in
            if snap.value != nil {
                
                self.dataList.removeAll()
                
                if let list = snap.value as? [String:AnyObject] {
                    let sortList = list.sort() { $0.0  < $1.0  }
                    
                    for (groupName, teams) in sortList {
                        
                        var teamList = [Team]()
                        
                        if let teamsData = teams as? [String:[String:AnyObject]] {
                            for (teamName, teamInfo) in teamsData {
                                
                                guard let teamPoint = teamInfo["Point"] as? Int else { continue }
                                
                                let team = Team(name: teamName, point: teamPoint)
                                teamList.append(team)
                            }
                        }
                        
                        if teamList.count > 0 {
                            let groupAndTeam = [ "Bảng \(groupName)" : teamList ]
                            self.dataList.append(groupAndTeam)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                }
            }
        })
    }
    
    func valueChanged() {
        self.database.child("Groups").queryOrderedByKey().observeEventType(.ChildChanged,withBlock: { (snap) in
            if snap.value != nil {
                if let list = snap.value as? [String:AnyObject] {
                    let sortList = list.sort() { $0.0  < $1.0  }
                    for groupData in sortList {
                        if let teamsData = groupData.1 as? [String:AnyObject] {
                            var teamList:[Team] = [Team]()
                            for teamData in teamsData {
                                var data:[String:AnyObject] = [
                                    "name" : teamData.0
                                ]
                                if let teamInfo = teamData.1 as? [String:AnyObject] {
                                    data["point"] = teamInfo["Point"]
                                    data["rank"] = teamInfo["Rank"]
                                }
                                if let team = Team(data: data) {
                                    teamList.append(team)
                                }
                            }
                            if teamList.count > 0 {
                                let group = [groupData.0:teamList]
                                self.dataList.append(group)
                            }
                            
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TeamsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        for (_,teamList) in self.dataList[section] {
            if let teams:[Team] = teamList {
                row = teams.count
            }
        }
        return row
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TeamsTableViewCell
        
        let group = self.dataList[indexPath.section]
        
        for (_, teams) in group {
            var teamsArr = teams.sort() { $0.point > $1.point }
            
            let team:Team = teamsArr[indexPath.row]
            
            let banner:UIImage = UIImage(named: "Banner-\(team.name)")!
            cell.bannerImageView.image = banner
            
            let logo:UIImage = UIImage(named: "\(team.name)")!
            cell.flagImageView.image = logo
            
            cell.countryLabel.text = team.name
            cell.pointLabel.text = "Điểm: \(team.point)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 40))
        let bg = UIImageView(frame: headerView.frame)
        bg.image = UIImage(named: "board")
        bg.contentMode = .ScaleAspectFill
        headerView.addSubview(bg)
        let textLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40 ))
        textLabel.font = UIFont(name: "Avenir Next Heavy", size: 25)
        textLabel.textColor = UIColor.whiteColor()
        let group = self.dataList[section]
        for (groupName, _) in group {
            textLabel.text = groupName
            headerView.addSubview(textLabel)
        }
        return headerView
    }
}

extension TeamsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let group = self.dataList[indexPath.section]
        
        for (_, teams) in group {
            var teamsArr = teams.sort() { $0.point > $1.point }
            
            let team:Team = teamsArr[indexPath.row]
            
            if let teamDetailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("teamDetailVC") as? TeamDetailsViewController {
                
                teamDetailsVC.teamData = team
                self.navigationController?.pushViewController(teamDetailsVC, animated: true)
            }
            
            break
        }

        
    }
    
}
