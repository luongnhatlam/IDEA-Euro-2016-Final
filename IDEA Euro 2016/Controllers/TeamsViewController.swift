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
    
    var loadingState:UIView = UIView()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.database = FIRDatabase.database().reference()
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func loadData() {
        loadingState = LoadingState.shareInstance.createLoadingState()
        self.view.addSubview(loadingState)
        tableView.userInteractionEnabled = false
        
        self.database.child("Groups").queryOrderedByKey().observeEventType(.Value,withBlock: { (snap) in
            
            
            if snap.value != nil {
                print(snap.value)
                self.dataList.removeAll()
                
                if let list = snap.value as? [String:AnyObject] {
                    
                    let sortList = list.sort() { $0.0  < $1.0  }
                    
                    for (groupName, teams) in sortList {
                        
                        var teamList = [Team]()
                        
                        if let teamsData = teams as? [String:[String:AnyObject]] {
                            
                            for (teamName, teamInfo) in teamsData {
                                
                                guard let teamPoint = teamInfo["Point"] as? Int else { continue }
                                
                                guard let teamRank = teamInfo["Rank"] as? Int else { continue }
                                
                                let team = Team(name: teamName, point: teamPoint, rank: teamRank )
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
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                            
                            UIView.animateWithDuration(0.25, animations: {
                                self.loadingState.layer.opacity = 0
                                }, completion: { (_) in
                                    self.loadingState.removeFromSuperview()
                                    self.tableView.userInteractionEnabled = true
                            })
                        }
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
        let thongTinBangDau = self.dataList[section]
        
        for (_,teamList) in thongTinBangDau {
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
            var teamsArr = teams.sort() { $0.rank < $1.rank }
            
            let team:Team = teamsArr[indexPath.row]
            
            cell.configureCellWithTeam(team)
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
        
        let bg = UIImageView(frame: headerView.bounds)
        bg.image = UIImage(named: "board")
        bg.contentMode = .ScaleAspectFill
        
        headerView.addSubview(bg)
        
        let textLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40 ))
        textLabel.font = UIFont(name: "Avenir Next Heavy", size: 25)
        textLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(textLabel)
        
        let group = self.dataList[section]
        textLabel.text = group.keys.first
        return headerView
    }
}





extension TeamsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let group = self.dataList[indexPath.section]
        
        for (_, teams) in group {
            var teamsArr = teams.sort() { $0.rank < $1.rank }
            
            let team:Team = teamsArr[indexPath.row]
            
            if let teamDetailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("teamDetailVC") as? TeamDetailsViewController {
                
                teamDetailsVC.teamData = team
                self.navigationController?.pushViewController(teamDetailsVC, animated: true)
            }
            
            break
        }

        
    }
    
}
