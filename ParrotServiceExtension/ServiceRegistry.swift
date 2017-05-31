import Foundation
import ParrotServiceExtension

public enum ServiceRegistry {
	
	/// TODO:
	public struct Account: ServiceOriginating {
		public let serviceIdentifier: String
		public let accountName: String
	}
	
	/// ServiceRegistry.didAddService:
	/// This notification is fired upon the discovery of a new Service type.
	public static let didAddService = Notification.Name(rawValue: "ServiceRegistry.didAddService")
	
	/// ServiceRegistry.didRemoveService:
	/// This notification is fired upon the removal of an existing Service type.
	public static let didRemoveService = Notification.Name(rawValue: "ServiceRegistry.didAddService")
	
	/// The set of all discovered Services that are available.
	/// Note that their connection states may vary and are not determinable automatically.
	public private(set) static var services = [String: Service]()
	
	/// Discovers and adds a Service to the ServiceRegistry.
	/// Note: `connect()` is not invoked on this Service.
	public static func add(service: Service) {
		let id = type(of: service).identifier
		guard ServiceRegistry.services[id] == nil else { return }
		
		ServiceRegistry.services[id] = service
		NotificationCenter.default.post(name: ServiceRegistry.didAddService, object: service)
	}
	
	/// Removes a Service from the ServiceRegistry.
	/// Note: `disconnect()` is not invoked on this Service.
	public static func remove(service: Service) {
		let id = type(of: service).identifier
		guard ServiceRegistry.services[id] != nil else { return }
		
		ServiceRegistry.services.removeValue(forKey: id)
		NotificationCenter.default.post(name: ServiceRegistry.didRemoveService, object: service)
	}
}
