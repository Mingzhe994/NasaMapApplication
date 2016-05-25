//
//  ViewController.swift
//  NasaMapApplication
//
//  Created by Stuart on 25/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//
//  reference Ben's example

import UIKit
import SDWebImage

class SatelliteViewController: UIViewController {

    @IBOutlet weak var satelliteImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    var latitude: Double?
    var longtitude: Double?
    var dim:Float?
    var APIkey = "GS38hoBuH5H3CVpqvR5gcoK3zIQzfIBCrevY3Nil"
    let apiBaseURL = "https://api.nasa.gov/planetary/earth/imagery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Satellite Map"
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        
        
        //let latitudeQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: "132.3")
        //let longtitudeQuery: NSURLQueryItem = NSURLQueryItem(name: "lon", value: "111.1")
        
        let dateQuery: NSURLQueryItem = NSURLQueryItem(name: "date", value: "2013-04-07")
        let apiKeyQuery:NSURLQueryItem = NSURLQueryItem(name: "api_key", value: APIkey)
        
        //urlComponents.queryItems = [longtitudeQuery,latitudeQuery,dateQuery,apiKeyQuery]
        urlComponents.queryItems = [dateQuery,apiKeyQuery]

        
        let url = urlComponents.URL!
        
        let request = NSMutableURLRequest(URL: url)
        
        //request.HTTPMethod = "GET"
        request.timeoutInterval = 120
        request.HTTPMethod = "GET"
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            //Something stuffed up:
            if let e = error  {
                
                print("error")
                print(e.localizedDescription)
                
                return
                
                //Check for issues with the status code:
            } else if let d = data, let r = response as? NSHTTPURLResponse{
                
                
                //perform the cast:
                print(r.statusCode)
                
                if (r.statusCode == 200){
                    print("It worked")
                    
                    var date: String?
                    var mapData: String?

                    
                    do {
                        let anyObj:NSDictionary = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                        // use anyObj here
                        
                        date = anyObj.valueForKey("date") as? String ?? "No Data"
                        mapData = anyObj.valueForKey("url") as? String ?? "No Data"
                        
                        //self.bookImageView.image = UIImage(
                        //print(imagelinks)
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                    
                    
                    
                    //You MUST perform UI updates on the main thread:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.timeStamp.text = date
                        let tmpUrl = NSURL(string: mapData!)
                        self.satelliteImage.sd_setImageWithURL(tmpUrl)
                    })
                    return
                }
                
            }
            
        }
        //This is important
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

