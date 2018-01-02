//
//  ViewController.swift
//  TikTokPinDrop2
//
//  Created by Arul Kapoor on 7/9/17.
//  Copyright © 2017 Arul Kapoor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    
    @IBOutlet var lbl: UILabel!
    @IBOutlet var searchBarMap: UISearchBar!
    var x = "2"
    var i = 0
    var timer = Timer()
        let annotation = MKPointAnnotation()
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func dSlider(_ sender: UISlider) {
        lbl.text="Sound alarm when "
        lbl.text!+=String(round(10*Double(sender.value))/10)
        x=String(round(10*Double(sender.value))/10)
        lbl.text!+=" miles away."
    }
    
    
    @IBOutlet var STOP: UIButton!
    
    @IBAction func PARA2(_ sender: UIButton) {
        STOP.isHidden=true
        audioPlayer.stop()
        STOP.layer.cornerRadius = 10
        STOP.clipsToBounds = true
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    

    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationU = locations[0]
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locationU.coordinate.latitude, locationU.coordinate.longitude)
        if(i==0){
            
            
            STOP.isHidden=true
            let spanU:MKCoordinateSpan = MKCoordinateSpanMake(0.075, 0.075)
            
            
            let regionU:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: spanU)
            
            self.mapView.setRegion(regionU, animated: true)
        }
        
        
        
        self.mapView.showsUserLocation = true
        
        if(i != 2){
            
            let target :CLLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let dist = target.distance(from: locationU)
            let check = Double(x)
            //check++
            if((dist/1600) < check!){
                STOP.isHidden = false
                i = 2
                audioPlayer.numberOfLoops = -1
                audioPlayer.currentTime = 0.0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                    
            }
                
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stop.hidden = true
        searchBarMap.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        do
        {
            let audioPath = Bundle.main.path(forResource: "1", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch
        {
            //error
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
       // STOP.isHidden = true
        i = 1
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBarMap.text!) {placemarks, error in
            if(error == nil){
                let placemark = placemarks?.first
                
                
                self.annotation.coordinate = (placemark!.location?.coordinate)!
                self.annotation.title = self.searchBarMap.text!
                
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: self.annotation.coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(self.annotation)
                self.mapView.selectAnnotation(self.annotation, animated: true)

                
            }
            else{
                print(error?.localizedDescription ?? "error")
            }
        }
    
        //print("Searching ...", searchBarMap.text!)
    }


}

