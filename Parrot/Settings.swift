import Foundation

/* TODO: Support suites. */

public typealias Settings = NSUserDefaults
public extension NSUserDefaults {
	
	public class func set(key: String, value: AnyObject?) {
		NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	public class func get(key: String) -> AnyObject? {
		return NSUserDefaults.standardUserDefaults().valueForKey(key)
	}
	
	public class func set(keys: [String: AnyObject?]) {
		for (key, value) in keys {
			NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
		}
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	public class func get(keys: [String]) -> [String: AnyObject?] {
		var map = [String: AnyObject?]()
		for (key) in keys {
			map[key] = NSUserDefaults.standardUserDefaults().valueForKey(key)
		}
		return map
	}
}

/*
private var _observers = [SettingsObserver]()
private class SettingsObserver : NSObject {
	private var path: String = ""
	private var ctx = 0
	private var action: (AnyObject? -> Void) = {a in }
	
	required init(path: String, action: (AnyObject? -> Void)) {
		super.init()
		self.path = "values." + path
		self.action = action
		
		print("obs path \(self.path)")
		
		NSUserDefaultsController.sharedUserDefaultsController().addObserver(self,
			forKeyPath: self.path, options: .New, context: nil)
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
		change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
			print("got \(path)")
			if let newValue = change?[NSKeyValueChangeNewKey] {
				print("got \(newValue)")
				action(newValue)
			}
	}
	
	deinit {
		NSUserDefaultsController.sharedUserDefaultsController().removeObserver(self,
			forKeyPath: self.path, context: nil)
		print("dead")
	}
}
*/
