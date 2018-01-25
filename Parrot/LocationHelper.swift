import CoreLocation

/// Locate the device's current location; return true from the handler to stop.
public func locate(reason: String, _ handler: @escaping (CLLocation?, Error?) -> (Bool)) {
    class CLLocator: NSObject, CLLocationManagerDelegate {
        var _self: CLLocator? = nil
        let manager = CLLocationManager()
        let handler: (CLLocation?, Error?) -> (Bool)
        
        init(_ reason: String, _ handler: @escaping (CLLocation?, Error?) -> (Bool)) {
            self.handler = handler
            super.init()
            _self = self
            
            self.manager.desiredAccuracy = 10.0
            self.manager.delegate = self
            self.manager.purpose = reason
            self.manager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            if handler(nil, error) {
                self.manager.stopUpdatingLocation()
                _self = nil
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if handler(locations.last, nil) {
                self.manager.stopUpdatingLocation()
                _self = nil
            }
        }
    }
    _ = CLLocator(reason, handler)
}
