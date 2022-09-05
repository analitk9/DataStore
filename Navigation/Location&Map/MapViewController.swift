//
//  MapViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 6/24/22.
//

import UIKit

import Foundation
import MapKit
import SwiftUI

final class MapViewController: UIViewController, MKMapViewDelegate {
    
    private lazy var mapView = MKMapView()
    
    private lazy var locationManager = CLLocationManager()
    
    private var longGesture = UILongPressGestureRecognizer()
    
    var destinationCoordinate: CLLocationCoordinate2D?
    
    init() {
        super.init(nibName: nil, bundle: nil)
       // configureTabBarItem()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .black)
        navigationItem.title = tabBarItem.title
        navigationItem.titleView?.tintColor = .createColor(lightMode: .white, darkMode: .black)
        configureNavigationBar()
        setupMapView()
        checkUserLocationPermissions()
       
        
    }
    
   private func configureTabBarItem() {
       tabBarItem.title = "location".localize()
        tabBarItem.image = UIImage(systemName: "globe.europe.africa")
        tabBarItem.selectedImage = UIImage(systemName: "globe.europe.africa.fill")
        tabBarItem.tag = 50
       
    }
    
  private  func configureNavigationBar(){
      let rightSaveButton = UIBarButtonItem(title: "Delete all pins".localize(), style: .plain, target: self, action: #selector(deleteAllPins))
        self.navigationItem.rightBarButtonItem = rightSaveButton
        
      let leftBeckButton = UIBarButtonItem(title: "Add Route".localize(), style: .plain, target: self, action: #selector(pressAddRoute))
        self.navigationItem.leftBarButtonItem = leftBeckButton
    }
    
    private func configureMapView() {
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longGesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(longGesture)
    }
    
  
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func deleteAllPins() {
        mapView.removeOverlays(self.mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    
    @objc func pressAddRoute() {
        addRoute()
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        let locationPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(locationPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.title = "Тут что-то интересное"
        annotation.subtitle = "Точно вам говорю!"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        destinationCoordinate = coordinate
    }
    
    private func setupCoordinateUser(){
        if let center = locationManager.location {
            let centerCoordinates = CLLocationCoordinate2D(latitude: (center.coordinate.latitude),
                                                           longitude:  (center.coordinate.longitude))
            mapView.setCenter(centerCoordinates, animated: true)
            let region = MKCoordinateRegion(center: centerCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkUserLocationPermissions() {
        locationManager.delegate = self
        // Проверяем наши разрешения на получение локации
        switch locationManager.authorizationStatus {
            
            // Если статус не ясен (еще не был показан алерт)
        case .notDetermined:
          
            locationManager.requestWhenInUseAuthorization()
            
            // Пользователь разрешил получать его геолокацию
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            configureMapView()
            
        case .denied, .restricted:
            print("Попросить пользователя зайти в настрйки")
            
        @unknown default:
            fatalError("Не обрабатываемый статус")
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    private func addRoute() {
        guard let destinationCoordinate = mapView.selectedAnnotations.first?.coordinate else {
            let alert = ErrorAlertService().createAlert("Нет выбранного пина")
            self.present(alert, animated: true)
            return
        }
        
        let directionRequest = MKDirections.Request()
        // source  наша координата  destinate  последний пин
        let sourcePlaceMark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        
        let destinationPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude))
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Высчитываем путь
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            self.mapView.removeOverlays(self.mapView.overlays)
            let route = response.routes[0]
            self.mapView.delegate = self
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setupCoordinateUser()
    }
    
}



