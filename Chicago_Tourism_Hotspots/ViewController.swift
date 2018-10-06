//
//  ViewController.swift
//  Chicago_Tourism_Hotspots
//
//  Created by Chance Potter on 10/1/18.
//  Copyright © 2018 Chance Potter. All rights reserved.
//
// API: AIzaSyAr-xtdqtokyTO303_ai2ZOo2oE9NFZ-Hc
//
// To-Do:   parse csv file
//          drop down menu instead of next button
//

import UIKit
import GoogleMaps
import GooglePlaces

// Maybe add snippet in future.
class Hotspot: NSObject {
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    let key: Int
    init(name: String, location: CLLocationCoordinate2D, zoom: Float, key: Int) {
        self.name = name
        self.location = location
        self.zoom = zoom
        self.key = key
    }
}

class ViewController: UIViewController {
    
    var mapView: GMSMapView?
    
    var currentDestination: Hotspot?
    
    let hotspots = [Hotspot(name: "O'Hare International Airport", location: CLLocationCoordinate2DMake(41.975092, -87.907343), zoom: 12, key: 1), Hotspot(name: "Willis Tower", location: CLLocationCoordinate2DMake(41.879108,-87.635915), zoom: 17, key: 2)]

    override func viewDidLoad() {
        super.viewDidLoad()

        startingView()
        
        parseCSVFile()
    }
    
    // To-do: Parse csv file so i dont put every location in an array of Hotspot
    func parseCSVFile() {
        let locationFile = "ChicagoTouristHotspots"
        if let filePath = Bundle.main.path(forResource: locationFile, ofType: "csv") {
            print("THIS IS THE FILE PATH: " + filePath)             // Debug
        }
        else {
            print("Could not find file")
        }
        
        
    }
    
    // Starting view when opening the app. Contains an overview of chicago and adds menubar.
    func startingView() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.879108, longitude: -87.635915, zoom: 8)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
    }   // end startingView()
    
    @objc func nextTapped() {
        if currentDestination == nil {
            currentDestination = hotspots.first
        } else {
            if let index = hotspots.index(of: currentDestination!) {
                if((index+1) < hotspots.count) {
                    currentDestination = hotspots[index + 1]
                }
            }
        }
        setCamera()
    } // end nextTapped()
    
    private func setCamera() {
        CATransaction.begin()
        CATransaction.setValue(1.5, forKey: kCATransactionAnimationDuration)
        
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentDestination!.location, zoom: currentDestination!.zoom))
        CATransaction.commit()
        let marker = GMSMarker(position: currentDestination!.location)
        marker.title = currentDestination!.name
        marker.map = mapView
    }   // end setCamera()

}

