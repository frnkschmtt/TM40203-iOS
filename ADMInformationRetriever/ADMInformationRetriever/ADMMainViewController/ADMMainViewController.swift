//
//  ViewController.swift
//  ADMInformationRetriever
//
//  Created by Frank Schmitt on 04.11.15.
//  Copyright © 2015 sovanta AG. All rights reserved.
//

import UIKit

class ADMMainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
	
	@IBOutlet weak var tfSearch: UITextField!
	@IBOutlet weak var tvResults: UITableView!
	@IBOutlet weak var scSource: UISegmentedControl!
	
	var manager: ADMInformationManager!
    let documentsPerSection: Int = 10
	var results: Array<ADMDocument> = [ADMDocument]()
	var totalResults: Int = 0
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		manager = ADMInformationManager(mockFilename: "mockdata")
		
		self.manager.curServer = self.manager.servers[self.scSource.selectedSegmentIndex]

//		print(manager)
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	override func viewWillAppear(animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func textFieldDidEndEditing(textField: UITextField)
	{
		print("\(__FUNCTION__)")
		
	}
	
	@IBAction func btnSearch_tapped(sender: AnyObject)
	{
		if(self.tfSearch.text == nil || self.tfSearch.text == "")
		{
			return
		}
		
		let paramDict = ["length":"10",
						"startIndex":"0",
						"search":["journal":self.tfSearch.text!,
							"authors":self.tfSearch.text!,
							"title":self.tfSearch.text!,
							"institutions":self.tfSearch.text!,
							"abstract":self.tfSearch.text!]]

		let query: ADMQuery = ADMQuery.init(params: paramDict)
//		let query: ADMQuery = ADMQuery.init(query: self.tfSearch.text!)
//        self.manager.sendQuery(query, server: self.manager.curServer, index: 0, length: self.documentsPerSection)
		
		self.manager.sendQuery(query, server: self.manager.curServer, index: 0, length: self.documentsPerSection) { (response, totalResults, error) -> Void in
			self.results = response as! Array<ADMDocument>
			self.totalResults = totalResults
			
			self.tvResults.reloadData()

		}
		
//        self.tvResults.reloadData()
	}
	
	@IBAction func segmentedControl_changed(sender: UISegmentedControl)
	{
		self.manager.curServer = self.manager.servers[sender.selectedSegmentIndex]
	}
	
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.totalResults/self.documentsPerSection//self.manager.query.totalResults/documentsPerSection
    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        let followingDocs: Int = self.totalResults-section*self.documentsPerSection//self.manager.query.totalResults-section*documentsPerSection
        return min(followingDocs, self.documentsPerSection)
	}
	
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "%i", section*self.documentsPerSection)
    }
    
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell:UITableViewCell = self.tvResults.dequeueReusableCellWithIdentifier("UITableViewCell")! as UITableViewCell
		
        let docNum: Int = indexPath.section*self.documentsPerSection+indexPath.row
        var lastDocNum: Int = self.results.count-1//self.manager.query.results.count-1
        
        var document: ADMDocument
        
        while(docNum>lastDocNum){
            self.manager.sendQuery(self.manager.query, server: self.manager.servers.first!, index: lastDocNum+1, length: self.documentsPerSection)
            lastDocNum = self.manager.query.results.count-1
        }
        
        document = self.results[docNum]//self.manager.query.results[docNum]
        
		cell.textLabel?.text = document.title
        
		return cell
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 20
	}
	
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//	{
////		[self performSegueWithIdentifier:@"yourSegue" sender:self];
//		self.performSegueWithIdentifier("detailSegue", sender: self)
//	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "detailSegue")
		{
			let vc = segue.destinationViewController as! ADMDetailViewController
			let indexPath = self.tvResults.indexPathForCell(sender as! UITableViewCell)
			let doc: ADMDocument! = self.results[indexPath!.row]//self.manager.query.results[indexPath!.row]
			if(doc != nil)
			{
				vc.doc = doc as ADMDocument
			}
		}
	}
	
	
	
}