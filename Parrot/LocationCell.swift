import MochaUI
import MapKit
import ParrotServiceExtension

/* TODO: Causes _NSDetectedLayoutRecursion. */

public class LocationCell: NSCollectionViewItem {
    
    private lazy var personView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var mapView: MKMapView = {
        let v = MKMapView().modernize(wantsLayer: true)
        v.mapType = .standard
        v.showsScale = true
        v.showsCompass = true
        v.showsBuildings = true
        v.showsUserLocation = true
        return v
    }()
    
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.mapView, self.personView) {
            self.personView.leftAnchor == self.view.leftAnchor + 8.0
            self.personView.bottomAnchor == self.view.bottomAnchor - 4.0
            self.personView.heightAnchor == 24.0
            self.personView.widthAnchor == 24.0
            
            self.mapView.leftAnchor == self.view.leftAnchor + 4.0
            self.mapView.rightAnchor == self.view.rightAnchor - 4.0
            self.mapView.topAnchor == self.view.topAnchor + 4.0
            self.mapView.bottomAnchor == self.view.bottomAnchor - 4.0
            
            // So, since the photoView can be hidden (height = 0), we should manually
            // declare the height minimum constraint here.
            //self.mapView.height >= 24.0 /* personView.height */
        }
    }
    
    public override var representedObject: Any? {
        didSet {
            guard let b = self.representedObject as? EventBundle else { return }
            guard let o = b.current as? Message else { return }
            guard case .location(let lat, let long) = o.content else { return }
            let prev = b.previous as? Message
            
            //self.orientation = b.current.sender.me ? .rightToLeft : .leftToRight // FIXME
            self.personView.image = o.sender.image
            self.personView.isHidden = /*(o.sender.me ?? false) || */(prev?.sender.identifier == o.sender.identifier)
            
            DispatchQueue.main.async {
                let annot = MKPointAnnotation()
                annot.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annot.title = o.sender.firstName
                annot.subtitle = "Sent " + b.current.timestamp.relativeString(numeric: true, seconds: false)
                self.mapView.addAnnotation(annot)
                self.mapView.region = MKCoordinateRegionMakeWithDistance(annot.coordinate, 200, 200)
            }
        }
    }
    
    /// Allows the circle crop and masking to dynamically change.
    public override func viewDidLayout() {
        if let layer = self.personView.layer {
            layer.masksToBounds = true
            layer.cornerRadius = layer.bounds.width / 2.0
        }
        
        self.mapView.layer?.masksToBounds = true
        self.mapView.layer?.cornerRadius = 10.0
    }
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    // EXPECTS: NSImage compatible data.
    public static func measure(_ width: CGFloat) -> CGFloat {
        return width
    }
}
