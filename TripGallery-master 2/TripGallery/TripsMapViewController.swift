//
//  TripsMapViewController.swift
//  TripGallery


import UIKit
import MapKit
import Foundation

class TripsMapViewController: UIViewController, MKMapViewDelegate, LocationObserver {
    
    
    
    @IBOutlet weak var tripsMap: MKMapView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        LocationService.shared.registerLocationObserver(locationObserver: self)
        
        Utilities.loadTrips()
        self.tripsMap.delegate = self
        tripsMap.setCenter(tripsMap.userLocation.coordinate, animated: true)
        for i in 0...Utilities.trips.count - 1{
            let trip = Utilities.trips[i]
            CLGeocoder().geocodeAddressString(trip.tripDestination, completionHandler: {
                (placeMark,error)in
                let tripLocation = placeMark![0].location?.coordinate
                self.tripsMap.addAnnotation(TripAnnotation(tripId : i, trip: trip, coordinate: tripLocation!))
            })
        }
        
        // Do any additional setup after loading the view.
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "tripAnnoation"
            let tripAnnoatation : TripAnnotation? = (annotation as? TripAnnotation)
            if tripAnnoatation == nil{
                return nil
            }
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if annotationView == nil{
                
                annotationView = MKAnnotationView(annotation: annotation,reuseIdentifier: reuseId)
                annotationView?.image = tripAnnoatation?.img
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
                annotationView?.canShowCallout = true
            }
            else{
                annotationView!.annotation = tripAnnoatation
            }
            return annotationView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationDidChange(newLocations: [CLLocation]) {
        self.tripsMap.setCenter(newLocations[0].coordinate, animated: true)
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
