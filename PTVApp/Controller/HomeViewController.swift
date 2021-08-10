//
//  HomeViewController.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var mapView = MKMapView()
    let searchButton : UIButton = {
       let button = UIButton()
        button.setTitle("Enter an Address", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(findStopsNearAddress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        button.backgroundColor = .white
        return button
    }()
    
    let takeMeAwayButton : UIButton = {
        let button = UIButton()
         button.setTitle("Take Me Away", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.addTarget(self, action: #selector(findStopsNearAddress), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.sizeToFit()
         button.backgroundColor = .black
         return button
     }()

    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        loadData()
    }
    
    func loadData() {
        addMapView()
        addButtonsToView()
        setUpLayout()
    }
    
    func getStops() {
        if let long = locationManager.location?.coordinate.longitude, let lat = locationManager.location?.coordinate.latitude {
        homeViewModel.getStops(long: long, lat: lat)
        let param = ["long":long,"lat":lat]
        homeViewModel.fetchStopsAroundLocation(param: param, completion: {
            (model, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                if let stopList = model {
                    DispatchQueue.main.async {
                        self.addAnnotations(stopList)
                    }
                }
                
            }
        })
        }
    }
    
    func addMapView() {
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight )
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.center = view.center
        
        view.addSubview(mapView)
    }
    
    func setUpLayout() {
        
        mapView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true

        searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.clipsToBounds = true
        
        
    }
    
    func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        }
    }
    
    func addAnnotations(_ stopList: StopsAroundLocation) {
        let stopAnnotationsList = self.homeViewModel.returnAnnotations(stopAroundLocation: stopList)
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations(stopAnnotationsList)
    }
    
    func addButtonsToView() {
        view.addSubview(searchButton)
        
    }
    
    @objc
    func findStopsNearAddress() {
        print("Button Pressed")
    }
    
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let stopAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            stopAnnotationView.animatesWhenAdded = true
            stopAnnotationView.titleVisibility = .adaptive
            stopAnnotationView.subtitleVisibility = .adaptive
            return stopAnnotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            whenLocationAvailable()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func whenLocationAvailable() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        view.addSubview(takeMeAwayButton)
        takeMeAwayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        takeMeAwayButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80).isActive = true
        takeMeAwayButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80).isActive = true
        takeMeAwayButton.layer.cornerRadius = 10
        takeMeAwayButton.layer.borderWidth = 1
        takeMeAwayButton.clipsToBounds = true
        getStops()
    }
}
