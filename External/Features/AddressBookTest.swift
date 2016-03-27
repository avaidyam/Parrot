//
//  AppDelegate.swift
//  test4
//
//  Created by Aditya Vaidyam on 1/11/16.
//  Copyright © 2016 Aditya Vaidyam. All rights reserved.
//

import Cocoa
import AddressBook

class Contact {
	class func doThings(window: NSWindow) {
		var item: ABPerson? = nil
		if let book = ABAddressBook.sharedAddressBook() {
			let people = book.people() as! [ABPerson]
			for person in people {
				item = person
			}
		}
		
		let view = ABPersonView(frame: NSMakeRect(0, 0, 386, 386))
		view.person = item
		view.editing = false
		view.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
		let vc = NSViewController()
		vc.view = view
		
		let popover = NSPopover()
		popover.contentViewController = vc
		popover.behavior = .Transient
		
		// quick hackysack
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
			popover.showRelativeToRect(window.contentView!.bounds, ofView: window.contentView!, preferredEdge: .MinY)
		}
		
		// open contacts
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "addressbook://\(item!.uniqueId)")!)
		
		// disable the plain background
		// bug: doesn't show properly with VibrantDark
		view.performSelector(Selector("setDrawsBackground:"), withObject: Bool(false))
		popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
	}
	
	class func debugThings() {
		let view = ABPersonView(frame: NSMakeRect(0, 0, 386, 386))
		
		func _printMethods(clazz: AnyClass) {
			var mc: CUnsignedInt = 0
			var mlist: UnsafeMutablePointer<Method> = class_copyMethodList(clazz, &mc);
			for var i: CUnsignedInt = 0; i < mc; i++ {
				print("\(method_getName(mlist.memory))")
				mlist = mlist.successor()
			}
		}
		
		print("\nABPersonView:")
		_printMethods(NSClassFromString("ABPersonView")!)
		let va = view.performSelector(Selector("_APIAdapter")).takeRetainedValue() as! NSObject
		print("\n\(va.dynamicType):")
		_printMethods(va.dynamicType)
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		Contact.doThings(self.window)
	}
}

