//
//  ADMDetailViewController.swift
//  ADMInformationRetriever
//
//  Created by Frank Schmitt on 07.11.15.
//  Copyright © 2015 sovanta AG. All rights reserved.
//

import UIKit

class ADMDetailViewController: UIViewController {

    override func viewDidLoad()
	{
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.navigationController?.setNavigationBarHidden(false, animated: true)

    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
