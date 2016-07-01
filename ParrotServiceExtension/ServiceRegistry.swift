import Foundation
import ParrotServiceExtension

public final class ServiceRegistry {
	private init() {}
	
	public static let didAddService = Notification.Name(rawValue: "ServiceRegistry.didAddService")
	public static let didRemoveService = Notification.Name(rawValue: "ServiceRegistry.didAddService")
	
	public private(set) static var services = [Service]()
	
	public static func add(service: Service) {
		let idx = ServiceRegistry.services.index { $0 === service }
		guard idx == nil else { return }
		
		ServiceRegistry.services.append(service)
		NotificationCenter.default().post(name: ServiceRegistry.didAddService, object: service)
	}
	
	public static func remove(service: Service) {
		let _idx = ServiceRegistry.services.index { $0 === service }
		guard let idx = _idx else { return }
		
		ServiceRegistry.services.remove(at: idx)
		NotificationCenter.default().post(name: ServiceRegistry.didRemoveService, object: service)
	}
}
