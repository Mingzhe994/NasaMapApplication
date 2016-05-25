//
//  ViewController.swift
//  NasaMapApplication
//
//  Created by Stuart on 25/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import UIKit

class SatelliteViewController: UIViewController {

    var latitude: Double?
    var longtitude: Double?
    var APIkey = "GS38hoBuH5H3CVpqvR5gcoK3zIQzfIBCrevY3Nil"
    let basicUrl = "https://api.nasa.gov/planetary/earth/imagery/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

