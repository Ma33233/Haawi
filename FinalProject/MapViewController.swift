//
//  MapViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 19/02/1444 AH.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
               let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
               self.view.addSubview(mapView)

               // Creates a marker in the center of the map.
               let marker = GMSMarker()
               marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
               marker.title = "Sydney"
               marker.snippet = "Australia"
               marker.map = mapView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
