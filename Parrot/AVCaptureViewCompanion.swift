import Cocoa
import Mocha
import AVKit
import AVFoundation
import CoreMediaIO

/// `AVCaptureViewCompanion` should be the delegate of the `AVCaptureView`.
/// This class simplifies the recording workflow. It does not record audio.
public final class AVCaptureViewCompanion: NSObject, AVCaptureViewDelegate, AVCaptureFileOutputRecordingDelegate {
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

public extension AVCaptureView {
    private static var companionProp = AssociatedProperty<AVCaptureView, AVCaptureViewCompanion>(.strong)
    
    @nonobjc public var companion: AVCaptureViewCompanion? {
        get { return AVCaptureView.companionProp[self] }
        set { AVCaptureView.companionProp[self] = newValue; self.delegate = newValue }
    }
}

/// `AVAudioLevelIndicatorViewPrivate` provides an internal/private API to `AVAudioLevelIndicatorView`.
/// It's similar to `NSLevelIndicator` but looks more "pro audio"-like.
/// Note: set `doubleValue` to something between 0.0 and 1.0 to display a value.
public let AVAudioLevelIndicatorViewType = NSClassFromString("AVAudioLevelIndicatorView") as? NSView.Type
