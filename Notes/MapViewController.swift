//
//  MapViewController.swift
//  Notes
//
//  Created by Gagan on 2018-04-14.
//  Copyright © 2018 My Org. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coords = locationCoordinates {
            let annotation = MKPointAnnotation()
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coords.latitude, longitude: coords.longitude)) { (placemarks, err) in
                if let placemark = placemarks?.first {
                    annotation.title = placemark.name
                    annotation.subtitle = placemark.locality
                }
            }
            let region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(0.01, 0.01))
            annotation.coordinate = coords
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(annotation)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
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
