import Foundation

public extension Timer {
	
	/// Trigger a notification every minute, starting from the next minute.
	public class func scheduledWallclock(_ target: AnyObject, selector: Selector) -> Timer {
		var comps = Calendar.current().components(_units, from: Date())
		comps.minute = (comps.minute ?? 0) + 1; comps.second = 0
		let date = Calendar.current().date(from: comps)!
		let timer = Timer(fireAt: date, interval: 60, target: target,
		                  selector: selector, userInfo: nil, repeats: true)
		RunLoop.main().add(timer, forMode: RunLoopMode.defaultRunLoopMode)
		return timer
	}
}
