//
//  ScheduleViewController.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/31/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit
import Firebase

class ScheduleViewController: UIViewController {
    
    var database:FIRDatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    var dataList:[Match] =  [Match]()
    var matchList:[String: [Match]] = [String: [Match]]()
    
    //    var sortedKey =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
        self.database = FIRDatabase.database().reference()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func loadData() {
        self.database.child("Matches").queryOrderedByKey().observeEventType(.Value,withBlock: { (snap) in
            if snap.value != nil {
                //                print(snap.value)
                self.dataList.removeAll()
                if let list = snap.value as? NSArray {
                    //                    let sortList = list.sort() { $0.0  < $1.0  }
                    //                    print(list.count)
                    for matchData in list {
                        if !(matchData is NSNull) {
                            //                            print(groupData)
                            if let data = matchData as? [String:AnyObject] {
                                if let match:Match = Match(data: data) {
                                    self.dataList.append(match)
                                }
                            }
                        }
                    }
                    
                    self.matchList =  self.getDataGroupByDate(self.dataList)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            }
        })
        
        
    }
    
    func getDataGroupByDate(data:[Match]) -> [String: [Match]] {
        
        var result:Dictionary<String,[Match]> = [String: [Match]]()
        for match in data {
            let dateStr = String.convertNSDateToDDMMYYYY(match.date)
            
            if let matchesOfDate = result[dateStr] {
                
                var matches = matchesOfDate
                matches.append(match)
                result[dateStr] = matches
                
            } else {
                result[dateStr] = [match]
            }
        }
        
        return result
    }
    
    func convertStringToDate(dateStr: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter.dateFromString(dateStr)
        return date!
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ScheduleViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.matchList.keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedMatchList = self.matchList.keys.sort() { self.convertStringToDate($0).timeIntervalSince1970 < self.convertStringToDate($1).timeIntervalSince1970 }
        //print(sortedMatchList)
        let key = sortedMatchList[section]
        return matchList[key]!.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        //let matchesOfDateIndex = self.matchList.startIndex.advancedBy(section)
        //let dateStr = self.matchList.keys[matchesOfDateIndex]
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 40))
        let bg = UIImageView(frame: headerView.frame)
        bg.image = UIImage(named: "board")
        bg.contentMode = .ScaleAspectFill
        headerView.addSubview(bg)
        let textLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40 ))
        textLabel.font = UIFont(name: "Avenir Next Heavy", size: 25)
        textLabel.textColor = UIColor.whiteColor()
        
        
        let sortedMatchList = self.matchList.keys.sort() { self.convertStringToDate($0).timeIntervalSince1970 < self.convertStringToDate($1).timeIntervalSince1970 }
        //print(sortedMatchList)
        let key = sortedMatchList[section]
        
        textLabel.text = key
        headerView.addSubview(textLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScheduleTableViewCell
        
        let sortedMatchList = self.matchList.keys.sort() { self.convertStringToDate($0).timeIntervalSince1970 < self.convertStringToDate($1).timeIntervalSince1970 }
        //print(sortedMatchList)
        let key = sortedMatchList[indexPath.section]
        
        if let matches = self.matchList[key] {
            
            let match = matches[indexPath.row]
            if let logoA = UIImage(named: "\(match.teamA)") {
                cell.teamALogo.image = logoA
            } else {
                cell.teamALogo.image = UIImage(named: "logo")
            }
            if let logoB = UIImage(named: "\(match.teamB)") {
                cell.teamBLogo.image = logoB
            }else {
                cell.teamBLogo.image = UIImage(named: "logo")
            }
            
            
            cell.dateLabel.text = String.showFormatDate(match.date)
            cell.goalTeamALabel.text = "\(match.goalsTeamA)"
            cell.goalTeamBLabel.text = "\(match.goalsTeamB)"
            cell.tvsLabel.text = match.tvs
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension ScheduleViewController : UITableViewDelegate {
    
}