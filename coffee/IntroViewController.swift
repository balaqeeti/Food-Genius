//
//  IntroViewController.swift
//  coffee
//
//  Created by admin on 10/30/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goToMap(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToMap", sender: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
