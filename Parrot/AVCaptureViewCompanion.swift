import MochaUI
import AVKit
import CoreMediaIO

public extension AVCaptureView {
    
    /// This method simplifies the recording workflow. It does not record audio.
    public func prepare(recordingURL: URL, completionHandler: @escaping (Error?) -> ()) {
        class AVCaptureViewCompanion: NSObject, AVCaptureViewDelegate, AVCaptureFileOutputRecordingDelegate {
            private let url: URL
            private let completionHandler: (Error?) -> ()
            
            public init(url: URL, completionHandler: @escaping (Error?) -> ()) {
                _ = AVCaptureViewCompanion.enableRemoteDeviceRecordingSource
                self.url = url
                self.completionHandler = completionHandler
            }
            
            // Opt in to iOS remote device recording.
            private static var enableRemoteDeviceRecordingSource: Void = {
                var property = CMIOObjectPropertyAddress(
                    mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
                    mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                    mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster)
                )
                var allow: UInt32 = 1
                let sizeOfAllow = MemoryLayout<UInt32>.size
                CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &property, 0, nil, UInt32(sizeOfAllow), &allow)
                return ()
            }()
            
            public func captureView(_ captureView: AVCaptureView, startRecordingTo fileOutput: AVCaptureFileOutput) {
                fileOutput.startRecording(to: self.url, recordingDelegate: self)
            }
            
            public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
                                   from connections: [AVCaptureConnection], error: Error?) {
                self.completionHandler(error)
            }
        }
        
        // Bootstrap the companion.
        let companion = AVCaptureViewCompanion(url: recordingURL) { [weak self] error in
            completionHandler(error)
            self?.companion = nil; self?.delegate = nil
        }
        self.companion = companion; self.delegate = companion
    }
    
    @nonobjc private var companion: AnyObject? {
        get { return AVCaptureView.companionProp[self] }
        set { AVCaptureView.companionProp[self] = newValue }
    }
    private static var companionProp = AssociatedProperty<AVCaptureView, AnyObject>(.strong)
}

/// `AVAudioLevelIndicatorViewPrivate` provides an internal/private API to `AVAudioLevelIndicatorView`.
/// It's similar to `NSLevelIndicator` but looks more "pro audio"-like.
/// Note: set `doubleValue` to something between 0.0 and 1.0 to display a value.
public let AVAudioLevelIndicatorViewType = NSClassFromString("AVAudioLevelIndicatorView") as? NSView.Type
