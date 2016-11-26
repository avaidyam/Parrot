import Foundation
import Mocha
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

// For initial release alerts.
// FIXME: Don't hardcode things.
public func checkForUpdates(_ buildTag: String, _ updateHandler: (GithubRelease) -> Void = {_ in}) {
    guard let release = GithubRelease.latest(prerelease: true) else { return }
    guard release.buildTag == buildTag else { return }
    
    let a = NSAlert()
    a.alertStyle = .informational
    a.messageText = "\(release.releaseName) available"
    a.informativeText = release.releaseNotes
    a.addButton(withTitle: "Update")
    a.addButton(withTitle: "Ignore")
    a.showsSuppressionButton = true // FIXME
    
    a.layout()
    a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
    a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
    if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
        updateHandler(release)
    }
}

