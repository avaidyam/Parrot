import Foundation
import AppKit
import Mocha
import MochaUI
import ParrotServiceExtension

public class PhotoCell: NSCollectionViewItem {
    
    private lazy var personView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = true
        v.isEditable = false
        v.animates = true
        v.imageAlignment = .alignCenter
        v.imageScaling = .scaleProportionallyUpOrDown
        return v
    }()
    
    public override func loadView() {
        self.view = NSVibrantView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        
        self.view.add(subviews: [self.personView, self.photoView])
        
        // Install constraints.
        self.personView.left == self.view.left + 8.0
        self.personView.bottom == self.view.bottom - 4.0
        self.personView.height == 24.0
        self.personView.width == 24.0
        
        self.photoView.left == self.personView.right + 8.0
        self.photoView.right == self.view.right - 8.0
        self.photoView.top == self.view.top + 4.0
        self.photoView.bottom == self.view.bottom - 4.0
        
        // So, since the photoView can be hidden (height = 0), we should manually
        // declare the height minimum constraint here.
        self.photoView.height >= 24.0 /* personView.height */
    }
    
    public override var representedObject: Any? {
        didSet {
            guard let b = self.representedObject as? MessageBundle else { return }
            guard case .image(let data, _) = b.current.content else { return }
            
            //self.orientation = b.current.sender!.me ? .rightToLeft : .leftToRight // FIXME
            self.personView.image = b.current.sender!.image
            self.personView.isHidden = /*(o.sender?.me ?? false) || */(b.previous?.sender?.identifier == b.current.sender?.identifier)
            self.photoView.image = NSImage(data: data)
        }
    }
    
    /// Allows the circle crop and masking to dynamically change.
    public override func viewDidLayout() {
        if let layer = self.personView.layer {
            layer.masksToBounds = true
            layer.cornerRadius = layer.bounds.width / 2.0
        }
        
        self.photoView.layer!.backgroundColor = .ns(.white)
        self.photoView.layer?.masksToBounds = true
        self.photoView.layer?.cornerRadius = 10.0
    }
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    // EXPECTS: NSImage compatible data.
    public static func measure(_ data: Data, _ width: CGFloat) -> CGFloat {
        let c = CGImageSourceCreateWithData(data as CFData, nil)!
        let q = CGImageSourceCopyPropertiesAtIndex(c, 0, nil) as! [String: Any]
        let pw = q[kCGImagePropertyPixelWidth as String] as! Int
        let ph = q[kCGImagePropertyPixelHeight as String] as! Int
        let dims = CGSize(width: pw, height: ph)
        
        return dims.height * ((width - 46.0) / dims.width)
    }
}
