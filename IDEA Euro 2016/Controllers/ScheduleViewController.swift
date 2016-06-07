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
    var sortedList:[String] = [String]()
    var loadingState:UIView = UIView()
    
    @IBOutlet weak var OLSearch: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScheduleViewController.createNotificationMatches), name: "alertMatch", object: nil)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let nsbundle = NSBundle.mainBundle()
        let nib = UINib(nibName: "MatchTableViewCell", bundle: nsbundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "cellSchedule")
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
        loadingState = LoadingState.shareInstance.createLoadingState()
        tableView.userInteractionEnabled = false
        self.view.addSubview(loadingState)
        self.database.child("Matches").queryOrderedByKey().observeEventType(.Value,withBlock: { (snap) in
            if snap.value != nil {
                self.dataList.removeAll()
                if let list = snap.value as? NSArray {
                    for matchData in list {
                        if !(matchData is NSNull) {
                            if let data = matchData as? [String:AnyObject] {
                                if let match:Match = Match(data: data) {
                                    self.dataList.append(match)
                                }
                            }
                        }
                    }
                    
                    self.matchList =  self.getDataGroupByDate(self.dataList)
                    self.sortedList = self.matchList.keys.sort() { self.convertStringToDate($0).timeIntervalSince1970 < self.convertStringToDate($1).timeIntervalSince1970 }
                    
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func createNotificationMatches() {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        UIApplication.sharedApplication().scheduledLocalNotifications?.removeAll()
        for match in self.dataList {
            let now = getGMT7(NSDate())
            if now.compare(getGMT7(match.date)) == .OrderedAscending {
                var dateFire:NSDate = calendar.dateByAddingUnit(.Hour, value: -4, toDate: match.date, options: [] )!
                
                var localNotification = UILocalNotification()
                localNotification.fireDate = dateFire
                localNotification.alertBody = "Trận đấu giữa \(match.teamA) và \(match.teamB) sẽ bắt đầu sau 4h nữa."
                localNotification.userInfo = ["notification": "Trận đấu giữa \(match.teamA) và \(match.teamB) sẽ bắt đầu sau 4h nữa."]
                localNotification.applicationIconBadgeNumber = 1
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
                dateFire = calendar.dateByAddingUnit(.Minute, value: -15, toDate: match.date, options: [] )!
                
                localNotification = UILocalNotification()
                localNotification.fireDate = dateFire
                localNotification.alertBody = "Trận đấu giữa \(match.teamA) và \(match.teamB) sẽ bắt đầu sau 15p nữa."
                localNotification.userInfo = ["notification": "Trận đấu giữa \(match.teamA) và \(match.teamB) sẽ bắt đầu sau 15p nữa."]
                localNotification.applicationIconBadgeNumber = 1
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
        print(UIApplication.sharedApplication().scheduledLocalNotifications)
    }
    
    
    func getGMT7(date: NSDate) -> NSDate {
        let tz = NSTimeZone.localTimeZone()
        let seconds:Double = Double(tz.secondsFromGMTForDate(date))
        return NSDate(timeInterval: seconds, sinceDate: date)
    }
    
}

extension ScheduleViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.matchList.keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.sortedList[section]
        return matchList[key]!.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 40))
        let bg = UIImageView(frame: headerView.frame)
        bg.image = UIImage(named: "board")
        bg.contentMode = .ScaleAspectFill
        headerView.addSubview(bg)
        let textLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40 ))
        textLabel.font = UIFont.init(name: "Avenir Next Heavy", size: 25)
        
        textLabel.textColor = UIColor.whiteColor()
        
        let key = self.sortedList[section]
        
        textLabel.text = key
        headerView.addSubview(textLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellSchedule", forIndexPath: indexPath) as! MatchTableViewCell
        
        let key = self.sortedList[indexPath.section]
        
        if let matches = self.matchList[key] {
            cell.configureCellWithMatch(matches, indexPath: indexPath)
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
