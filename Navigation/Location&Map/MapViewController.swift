//
//  MapViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 6/24/22.
//

import UIKit

import Foundation
import MapKit

final class MapViewController: UIViewController {

    private lazy var mapView = MKMapView()

    private lazy var locationManager = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        
      
        setupMapView()
        checkUserLocationPermissions()
       // configureMapView()

    }

    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


private func configureMapView() {
       // Задаем тип карты - спутник\карта\гибрид\другие типы от apple
       mapView.mapType = .hybrid
       mapView.showsUserLocation = true
    
       // Задаем центр карты по нашей координате
    let centerCoordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude,
                                                   longitude:  locationManager.location?.coordinate.longitude)
       mapView.setCenter(centerCoordinates, animated: true)

       // Задаем zoom (MKMapView не имеет данного свойства)
       DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
           let region = MKCoordinateRegion(center: centerCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
           self?.mapView.setRegion(region, animated: true)
       }
   }

private func checkUserLocationPermissions() {
      // Проверяем наши разрешения на получение локации
      switch locationManager.authorizationStatus {

      // Если статус не ясен (еще не был показан алерт)
      case .notDetermined:
          locationManager.delegate = self
          locationManager.requestWhenInUseAuthorization()

      // Пользователь разрешил получать его геолокацию
      case .authorizedAlways, .authorizedWhenInUse:
         
          configureMapView()

      case .denied, .restricted:
          print("Попросить пользователя зайти в настрйки")

      @unknown default:
          fatalError("Не обрабатываемый статус")
      }

  }
}

extension MapViewController: CLLocationManagerDelegate {

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      checkUserLocationPermissions()
  }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location = locations.first else { return }

          let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
          mapView.setRegion(region, animated: true)
      }

    private func addPins() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 59.93, longitude: 30.30)
        pin.title = "Наш пин"
        mapView.addAnnotation(pin)
    }

    private func addRoute() {
           let directionRequest = MKDirections.Request()

           let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 59.93, longitude: 30.30))
           let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)

           let destinationPlaceMark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
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

               let route = response.routes[0]
               self.mapView.delegate = self
               self.mapView.addOverlay(route.polyline, level: .aboveRoads)

               let rect = route.polyline.boundingMapRect
               self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
           }
       }

       func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

           let renderer = MKPolylineRenderer(overlay: overlay)

           renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

           renderer.lineWidth = 5.0

           return renderer
       }

}



