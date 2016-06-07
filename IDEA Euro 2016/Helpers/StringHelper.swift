//
//  StringHelper.swift
//  IDEA Euro 2016
//
//  Created by Tran Viet on 6/1/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit

extension String {
    
    static func showFormatDate(date:NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let hour = calendar.component(.Hour,fromDate: date)
        let day = calendar.component(.Day,fromDate: date)
        let month = calendar.component(.Month,fromDate: date)
        let minute = calendar.component(.Minute, fromDate: date)
        
        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        let dayStr = day < 10 ? "0\(day)" : "\(day)"
        let monthStr = month < 10 ? "0\(month)" : "\(month)"
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        
        let dateStr:String = "\(dayStr)/\(monthStr) - \(hourStr):\(minuteStr)"
        return dateStr
    }
    
    static func showFormatTime(date:NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let hour = calendar.component(.Hour,fromDate: date)
        let minute = calendar.component(.Minute, fromDate: date)
        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        
        let dateStr:String = "\(hourStr):\(minuteStr)"
        return dateStr
    }
    
    static func convertNSDateToDDMMYYYY(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let day = calendar.component(.Day,fromDate: date)
        let month = calendar.component(.Month,fromDate: date)
        let year = calendar.component(.Year, fromDate: date)
        let dayStr = day < 10 ? "0\(day)" : "\(day)"
        let monthStr = month < 10 ? "0\(month)" : "\(month)"
        return "\(dayStr)/\(monthStr)/\(year)"
    }
}
