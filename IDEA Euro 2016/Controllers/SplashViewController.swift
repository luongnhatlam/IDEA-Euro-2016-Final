//
//  SplashViewController.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/30/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var OLDanhSachDoi: UIButton!
    @IBOutlet weak var OLLichThiDau: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        radiusBorder()
//        self.navigationController?.navigationBar.barTintColor
    }
    
    func radiusBorder(){
        OLLichThiDau.layer.cornerRadius = 10
        OLDanhSachDoi.layer.cornerRadius = 10
        //OLLichThiDau.layer.masksToBounds = true
        //OLDanhSachDoi.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
