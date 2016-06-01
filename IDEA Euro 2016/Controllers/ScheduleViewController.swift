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
    var matchList:[[String:[Match]]] = [[String:[Match]]]()
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
                    
                    print(self.getDataGroupByDate(self.dataList))
                    
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScheduleTableViewCell
        let match = self.dataList[indexPath.row]
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
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension ScheduleViewController : UITableViewDelegate {
    
}