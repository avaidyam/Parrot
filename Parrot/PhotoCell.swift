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
    
    private var incrementalImage: CGIncrementalImage? = nil
    
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.personView, self.photoView)
        
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
            guard case .image(let url) = b.current.content else { return }
            
            //self.orientation = b.current.sender!.me ? .rightToLeft : .leftToRight // FIXME
            self.personView.image = b.current.sender!.image
            self.personView.isHidden = /*(o.sender?.me ?? false) || */(b.previous?.sender?.identifier == b.current.sender?.identifier)
            
            // Set up incremental loading of the image from the url.
            self.incrementalImage = CGIncrementalImage(url: url) { image, _, _ in
                self.photoView.image = image
            }
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
    public static func measure(_ url: URL, _ width: CGFloat) -> CGFloat {
        if let dims = PhotoCell.urlSizeMap[url] {
            return dims.height * ((width - 46.0) / dims.width)
        } else {
            
            // Download and cache the info here.
            let header = CGIncrementalImage.retrieve(headersOf: url)
            let dims = header?.size ?? .zero
            PhotoCell.urlSizeMap[url] = dims
            
            return dims.height * ((width - 46.0) / dims.width)
        }
    }
    
    /// Cache the URL to a size; not sure if we should expect the same url to return
    /// different sizes at any point, so this may be inaccurate. (Reload it maybe?)
    private static var urlSizeMap: [URL: CGSize] = [:]
}
