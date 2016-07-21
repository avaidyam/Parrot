import Foundation
import AddressBook
import protocol ParrotServiceExtension.Person

public func searchContacts(person user: Person) -> [ABPerson] {
	var possible = [ABSearchElement]()
	for location in user.locations {
		possible.append(ABPerson.searchElement(
			forProperty: kABEmailProperty, label: "", key: "", value: location,
			comparison: ABSearchComparison(kABEqualCaseInsensitive.rawValue))!
		)
		possible.append(ABPerson.searchElement(
			forProperty: kABPhoneProperty, label: "", key: "", value: location,
			comparison: ABSearchComparison(kABEqualCaseInsensitive.rawValue))!
		)
	}
	
	let records = ABAddressBook.shared().records(
		matching: ABSearchElement(forConjunction:
			ABSearchConjunction(kABSearchOr.rawValue), children: possible)
	)!.flatMap { $0 as? ABPerson }
	return records
}
