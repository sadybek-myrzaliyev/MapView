//
//  ViewController.swift
//  MapView.HomeWork
//
//  Created by Садыбек Мырзалиев on 25.10.2026.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var addresLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelNameOfHotel: UILabel!
    
    @IBOutlet weak var labelOfAdress: UILabel!
    
    @IBOutlet weak var miniMap: MKMapView!
    
    var hotels = NameOfHotels(lat:  0.01, long:  0.01)
    
    var followMe = false
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showHotelOnMap()
        
        labelNameOfHotel.text = hotels.nameOfHotels
        labelOfAdress.text = hotels.addresOfHotels
        imageView.image = UIImage(named: hotels.images)
        
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
        miniMap.addGestureRecognizer(mapDragRecognizer)
        
        
        
        // Настраиваем долгое нажатие - добавляем новые метки на карту
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        // минимально 2 секунды
        longPress.minimumPressDuration = 2
        miniMap.addGestureRecognizer(longPress)
        
        // MKMapViewDelegate - чтоб отслеживать нажатие на метки на карте (метод didSelect)
        miniMap.delegate = self
        
        
        
    }
    
    // Вызывается каждый раз при изменении местоположения нашего пользователя
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        print(userLocation)
        
    }
    
    // Вызывается когда двигаем карту
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        // Как только начали двигать карту
        if (gestureRecognizer.state == UIGestureRecognizer.State.ended) {
            
            
            print("Map drag changed")
        }
    }
    
    // Долгое нажатие на карту - добавляем новые метки
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        print("gestureRecognizer")
        
        // Получаем точку нажатия на экране
        let touchPoint = gestureRecognizer.location(in: miniMap)
        
        // Конвертируем точку нажатия на экране в координаты пользователя
        let newCoor: CLLocationCoordinate2D = miniMap.convert(touchPoint, toCoordinateFrom: miniMap)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        anotation.coordinate = newCoor
        
        anotation.title = "Title"
        anotation.subtitle = "subtitle"
        
        miniMap.addAnnotation(anotation)
        
        
    }
    
    
    // MARK: -  MapView delegate
    // Вызывается когда нажали на метку на карте
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.lightGray
        // Ширина линии
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
    
    
    
    @IBAction func selected(_ sender: Any) {
        
        let mapVС = storyboard?.instantiateViewController(identifier: "MapView") as! MapViewController
        
        mapVС.hotels = hotels
        
        mapVС.userLocation = userLocation
        
        navigationController?.show(mapVС, sender: self)
        
        
    }
    
    func showHotelOnMap() {
        
        let lat:CLLocationDegrees = hotels.lat
        let long:CLLocationDegrees = hotels.long
        // Создаем координта передавая долготу и широту
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        
        // Задаем коортинаты метке
        anotation.coordinate = location
        // Задаем название метке
        anotation.title =  hotels.nameOfHotels
        // Задаем описание метке
        anotation.subtitle = hotels.addresOfHotels
        // Добавляем метку на карту
        miniMap.addAnnotation(anotation)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        // Создаем область шириной и высотой по дельте
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // Создаем регион на карте с моими координатоми в центре
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Приближаем карту с анимацией в данный регион
        miniMap.setRegion(region, animated: true)
        
        
    }
}
