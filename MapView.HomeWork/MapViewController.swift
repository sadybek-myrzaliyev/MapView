//
//  MapViewController.swift
//  MapView.HomeWork
//
//  Created by Садыбек Мырзалиев on 26.10.2026.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var followMe = false
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    var hotels = NameOfHotels(lat: 0.01, long: 0.01)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDestination()
        // Запрос для использования местоположения пользователя
        locationManager.requestWhenInUseAuthorization()
        
        // delegate нужен для функции didUpdateLocations, которая вызывается при обновлении местоположения (для этого прописали CLLocationManagerDelegate выше)
        locationManager.delegate = self
        
        // Запускаем слежку за пользователем
        locationManager.startUpdatingLocation()
        
        // Настраиваем отслеживания жестов - когда двигается карта вызывается didDragMap
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap))
        
        // UIGestureRecognizerDelegate - чтоб мы могли слушать нажатия пользователя по экрану и отслеживать конкретные жесты
        mapDragRecognizer.delegate = self
        
        // Добавляем наши настройки жестов на карту
        mapView.addGestureRecognizer(mapDragRecognizer)
        
        // ______________ Метка на карте ______________
        // Новые координаты для метки на карте
        let lat:CLLocationDegrees = hotels.lat
        let long:CLLocationDegrees = hotels.long
        // Создаем координта передавая долготу и широту
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        
        // Задаем коортинаты метке
        anotation.coordinate = location
        // Задаем название метке
        anotation.title = hotels.nameOfHotels
        // Задаем описание метке
        anotation.subtitle = hotels.addresOfHotels
        // Добавляем метку на карту
        mapView.addAnnotation(anotation)
        
        // Настраиваем долгое нажатие - добавляем новые метки на карту
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        // минимально 2 секунды
        longPress.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPress)
        
        // MKMapViewDelegate - чтоб отслеживать нажатие на метки на карте (метод didSelect)
        mapView.delegate = self
        
        
        
    }
    
    // Вызывается каждый раз при изменении местоположения нашего пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        print(userLocation)
        
        if followMe {
            // Дельта - насколько отдалиться от координат пользователя по долготе и широте
            
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            
            // Создаем область шириной и высотой по дельте
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
            // Создаем регион на карте с моими координатоми в центре
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            // Приближаем карту с анимацией в данный регион
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    @IBAction func showMyLocation(_ sender: Any) {
        
        followMe = true
        
    }
    // Вызывается когда двигаем карту
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        // Как только начали двигать карту
        if (gestureRecognizer.state == UIGestureRecognizer.State.ended) {
            
            // Говорим не следовать за пользователем
            followMe = false
            
            print("Map drag changed")
        }
    }
    
    // Долгое нажатие на карту - добавляем новые метки
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        print("gestureRecognizer")
        
        // Получаем точку нажатия на экране
        let touchPoint = gestureRecognizer.location(in: mapView)
        
        // Конвертируем точку нажатия на экране в координаты пользователя
        let newCoor: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        anotation.coordinate = newCoor
        
        anotation.title = "Title"
        anotation.subtitle = "subtitle"
        
        mapView.addAnnotation(anotation)
    }
    
    
    // MARK: -  MapView delegate
    // Вызывается когда нажали на метку на карте
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.blue
        // Ширина линии
        renderer.lineWidth = 2.0
        
        return renderer
    }

    func setDestination(){
        
                    
            
            // Получаем координаты метки
        let location:CLLocation = CLLocation(latitude: (hotels.lat), longitude: hotels.long)
            
            // Считаем растояние до метки от нашего пользователя
            let meters:CLLocationDistance = location.distance(from: userLocation)
            distanceLabel.text = String(format: "Distance: %.2f m", meters)
            
            
            // Routing - построение маршрута
            // 1 Координаты начальной точки А и точки B
            let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            let destinationLocation = CLLocationCoordinate2D(latitude: hotels.lat, longitude:  hotels.long)
            
            // 2 упаковка в Placemark
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            // 3 упаковка в MapItem
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            // 4 Запрос на построение маршрута
            let directionRequest = MKDirections.Request()
            // указываем точку А, то есть нашего пользователя
            directionRequest.source = sourceMapItem
            // указываем точку B, то есть метку на карте
            directionRequest.destination = destinationMapItem
            // выбираем на чем будем ехать - на машине
            directionRequest.transportType = .automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            // 5 Запускаем просчет маршрута
            directions.calculate {
                (response, error) -> Void in
                
                // Если будет ошибка с маршрутом
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                // Берем первый машрут
                let route = response.routes[0]
                // Удалить все существующие маршруты
                self.mapView.removeOverlays(self.mapView.overlays)
                // Рисуем на карте линию маршрута (polyline)
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                // Приближаем карту с анимацией в регион всего маршрута
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        // didSelect

    }

            }
    



