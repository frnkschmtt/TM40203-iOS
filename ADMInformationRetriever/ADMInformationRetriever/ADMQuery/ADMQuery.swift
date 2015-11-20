//
//  ADMQuery.swift
//  ADMInformationRetriever
//
//  Created by Florian Panzer on 07.11.15.
//  Copyright © 2015 sovanta AG. All rights reserved.
//

import UIKit

class ADMQuery: NSObject{
    var query: String = ""
	var params: NSDictionary = NSDictionary()
    var results: Array<ADMDocument> = [ADMDocument]()
    var totalResults: Int = 0
    var resultsPerPage: Int = 0
	
	init(params: NSDictionary)
	{
		self.params = params
	}
	
    init(query: String)
	{
        self.query = query
    }
	
    func send(index: Int, length: Int, urlString: String) -> Bool {
        let url: NSURL = NSURL.init(fileURLWithPath: urlString)
        let request: NSMutableURLRequest = NSMutableURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        request.HTTPMethod = "GET"

        do{
			let bundle = NSBundle.mainBundle()
			let path = bundle.pathForResource("20151107_pubmed_mock", ofType: "json")
			let data:NSData = NSData(contentsOfFile: path!)!
			
			do
			{
				if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
				{
					self.results = getDocumentsForResult(jsonResult.objectForKey("results") as! [NSDictionary])
					self.totalResults = self.results.count
					self.resultsPerPage = 10
				}
			}
			catch
			{
				print(error)
			}
			
			
        }
        catch { return false }
        return true
    }
	
	typealias QueryResponseBlock = (results:AnyObject?, totalResults: Int, error:NSError?) -> Void

	func send(index: Int, length: Int, urlString: String, completionHandler: QueryResponseBlock) -> Void
	{
//		let url = NSURL(string: urlString)
		self.query = urlString+self.buildQuery(self.params)
		let urlStr : NSString = self.query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

		let url = NSURL(string: urlStr as String)
		
		if(NSURL(string: urlString)!.lastPathComponent == "20151107_pubmed_mock.json")
		{
//			let bundle = NSBundle.mainBundle()
//			let path = bundle.pathForResource("20151107_pubmed_mock", ofType: "json")
			let data:NSData = NSData(contentsOfFile: urlString)!
			
			do
			{
				if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
				{
					self.results = self.getDocumentsForResult(jsonResult.objectForKey("results") as! [NSDictionary])
					self.totalResults = self.results.count
					self.resultsPerPage = 10
					
					completionHandler(results: self.results, totalResults: self.totalResults, error: nil)

				}
			}
			catch
			{
				print(error)
			}
		}
		else
		{
			let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
				print(NSString(data: data!, encoding: NSUTF8StringEncoding))
				
				do
				{
					if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
					{
						self.results = self.getDocumentsForResult(jsonResult.objectForKey("QueryResult")!.objectForKey("results") as! [NSDictionary])
						self.totalResults = self.results.count
						self.resultsPerPage = 10
						
						completionHandler(results: self.results, totalResults: self.totalResults, error: nil)
						
					}
				}
				catch
				{
					print(error)
				}
//				completionHandler(response: response, totalResults: self.totalResults, error: error)
			}
			
			task.resume()
		}
//		completionHandler(response: <#T##AnyObject?#>, success: <#T##Bool?#>)
	}
	
	
	func getDocumentsForResult(results: [NSDictionary]) -> [ADMDocument]
	{
		var arrayDocuments = [ADMDocument]()
		
		for dict in results
		{
			var arrayAuthors = [ADMAuthor]()
			for authorName in dict["authors"] as! Array<String>
			{
				let author = ADMAuthor(name: authorName)
				arrayAuthors.append(author)
			}
			
			let doc = ADMDocument(id: dict["id"]! as! String, journal: dict["journal"] as! String, title: dict["title"] as! String, authors: dict["authors"] as! Array<ADMAuthor>, institutions: dict["institutions"] as! String, abstract: dict["abstract"] as! String, pmid: dict["pmid"] as! String, url: "http://hcbi.nlm.nih.gov/pubmed/?term=", rank: (dict["ranking"] as! Float))
			arrayDocuments.append(doc)
		}
		
		return arrayDocuments
	}
	
	func buildQuery(params: NSDictionary) -> String
	{
		var fullQuery: String = "query?"
//		for key : AnyObject in params.allKeys
		for (index, element) in params.allKeys.enumerate()
		{
			let stringKey = element as! String
//			if let keyValue = ocDictionary.valueForKey(stringKey){
//				swiftDict[stringKey] = keyValue
//			}
			
			
			
			if(stringKey == "search")
			{
				var subQueryStr: String = "search="
				for (subIndex, element) in (params["search"]?.allKeys.enumerate())!
				{
					let stringSubKey = element as! String

					if let subKeyValue = params["search"]!.valueForKey(stringSubKey)
					{
						subQueryStr.appendContentsOf( String(format: "%@:%@*", stringSubKey, subKeyValue as! String) )
					}
//					var curStr: String = key+":"+params["query"][key]
//					queryStr.appendContentsOf()
					
					if(subIndex < (params["search"]?.allKeys.count)!-1)
					{
						subQueryStr.appendContentsOf(" OR ")
					}
					
				}
				fullQuery.appendContentsOf(subQueryStr)
			}
			else
			{
				if let keyValue = params.valueForKey(stringKey)
				{
					fullQuery.appendContentsOf( String(format: "%@=%@", stringKey, keyValue as! String) )
				}
			}
			
			if(index < params.allKeys.count-1)
			{
				fullQuery.appendContentsOf("&")
			}
		}
		
		return fullQuery
	}
}
