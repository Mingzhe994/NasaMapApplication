//
//  ViewController.swift
//  NasaMapApplication
//
//  Created by Stuart on 25/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//
//  reference Ben's example
//  reference https://grokswift.com/building-urls/
//  reference SDWebimage https://github.com/rs/SDWebImage

import UIKit
import SDWebImage

class SatelliteViewController: UIViewController {

    @IBOutlet weak var satelliteImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    var latitude: Float?
    var longtitude: Float?
    var APIkey = "GS38hoBuH5H3CVpqvR5gcoK3zIQzfIBCrevY3Nil"
    let apiBaseURL = "https://api.nasa.gov/planetary/earth/imagery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Satellite Map"
        satelliteImage.image = UIImage(named: "loading")
        

        
        //performNASARequest(nowDate)
        SDImageCache.sharedImageCache().clearDisk()
        performNASARequestSequence()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performNASARequest(date: NSDate, thread: Int){
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        latitude = -34.424984
        //let text = NSString(format: "%.2f", latitude!)
        
        longtitude = 150.8931239
        
        let latitudeQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: String(latitude!))
        let longtitudeQuery: NSURLQueryItem = NSURLQueryItem(name: "lon", value: String(longtitude!))
        let cloudScoreQuery: NSURLQueryItem = NSURLQueryItem(name: "cloud_score", value: "true")
        let dateQuery: NSURLQueryItem = NSURLQueryItem(name: "date", value: dateToString(date))
        let apiKeyQuery:NSURLQueryItem = NSURLQueryItem(name: "api_key", value: APIkey)
        
        urlComponents.queryItems = [longtitudeQuery,latitudeQuery,dateQuery,cloudScoreQuery,apiKeyQuery]
        //urlComponents.queryItems = [dateQuery,apiKeyQuery]
        
        
        let url = urlComponents.URL!
        
        let request = NSMutableURLRequest(URL: url)
        
        //request.HTTPMethod = "GET"
        request.timeoutInterval = 120
        request.HTTPMethod = "GET"
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            print(" This is thread : \(thread)")

            //Something stuffed up:
            if let e = error  {
                
                print("error")
                print(e.localizedDescription)
                
                return
                
                //Check for issues with the status code:
            } else if let d = data, let r = response as? NSHTTPURLResponse{
                
                
                //perform the cast:
                //print(r.statusCode)
                
                if (r.statusCode == 200){
                    print("It worked")
                    
                    var date: String?
                    var mapData: String?
                    //let resultString:String = NSString(data: d, encoding:NSUTF8StringEncoding)! as String
                    //print(resultString)
                    do {
                        let anyObj:NSDictionary = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                        // use anyObj here
                        
                        date = anyObj.valueForKey("date") as? String ?? "No Data"
                        mapData = anyObj.valueForKey("url") as? String ?? "No Data"
                        print("Date: ",date!)

                        //print(imagelinks)
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                    
                    let tmpUrl = NSURL(string: mapData!)
                    SDWebImageManager.sharedManager().downloadImageWithURL(tmpUrl, options: SDWebImageOptions(), progress: { (min:Int, max:Int) -> Void in
                        
                        //print("loading...")
                        
                    }) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url:NSURL!) -> Void in
                        
                        if (image != nil)
                        {
                            print("finish \(tmpUrl!)")
                        }
                    }
                    
                    //You MUST perform UI updates on the main thread:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.timeStamp.text = date
                        self.satelliteImage.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(String(tmpUrl))
                    })
                    return
                }
                
            }
            
        }
        //This is important
        task.resume()
    }
    
    
   func performNASARequestSequence(){
        let nowDate = NSDate()
        var calculatedDate = nowDate
        let rangeOfMonth = -2
    
        for calculate in 0...4{
            performNASARequest(calculatedDate, thread: calculate)
            calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: rangeOfMonth*calculate, toDate: nowDate, options: NSCalendarOptions.init(rawValue: 0))!
        }
   }
    
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
}

