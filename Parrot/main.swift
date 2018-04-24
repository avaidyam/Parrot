import Cocoa
autoreleasepool {
    var delegate: NSApplicationDelegate? = ParrotAppController()
    withExtendedLifetime(delegate) {
        NSApplication.shared.delegate = delegate
        NSApplication.shared.run()
    }
    delegate = nil
}
