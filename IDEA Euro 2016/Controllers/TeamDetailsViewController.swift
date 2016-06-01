//
//  TeamDetailsViewController.swift
//  IDEA Euro 2016
//
//  Created by Tran Viet on 6/1/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit
import Firebase

class TeamDetailsViewController: UIViewController {
    
    var database:FIRDatabaseReference!
    
    var teamData:Team?
    var matchesList:Array<Match> = [Match]()
    var loadingState:UIView = UIView()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        let nsbundle = NSBundle.mainBundle()
        let nib = UINib(nibName: "MatchTableViewCell", bundle: nsbundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "cellSchedule")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title = teamData?.name
        
        
        self.database = FIRDatabase.database().reference()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load data
    
    func loadData() {
        loadingState = LoadingState.shareInstance.createLoadingState()
        self.view.addSubview(loadingState)
        self.database.child("Matches").queryOrderedByKey().observeEventType(.Value,withBlock: { (snap) in
            if snap.value != nil {
                
                self.matchesList.removeAll()
                if let list = snap.value as? NSArray {
                    
                    for matchData in list {
                        if !(matchData is NSNull) {
                            
                            if let data = matchData as? [String:AnyObject] {
                                if let match:Match = Match(data: data), team = self.teamData {
                                    
                                    if(match.teamA == team.name || match.teamB == team.name) {
                                        self.matchesList.append(match)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                            
                            UIView.animateWithDuration(0.25, animations: {
                                self.loadingState.layer.opacity = 0
                                }, completion: { (_) in
                                    self.loadingState.removeFromSuperview()
                            })
                        }
                    })
                }
            }
        })
    }

}

extension TeamDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : matchesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = (indexPath.section == 0) ? "cellDetail" : "cellSchedule"
        
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TeamsTableViewCell
            
            if let team = teamData {
                cell.configureCellWithTeam(team)
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
            
            cell.configureCellWithMatch(self.matchesList, indexPath: indexPath)
            
            return cell
        }
        
    }
}

extension TeamDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 0 : 40
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
        
        textLabel.text = "Lịch thi đấu"
        headerView.addSubview(textLabel)
        
        return headerView
    }
}
