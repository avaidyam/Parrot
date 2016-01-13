import Cocoa

// from @Monolo: http://stackoverflow.com/questions/10463680/how-to-let-nstextfield-grow-with-the-text-in-auto-layout
public class PRTTextField: NSTextField {
	
	public override var intrinsicContentSize: NSSize {
		if !self.cell!.wraps {
			return super.intrinsicContentSize
		}
		
		var frame = self.frame
		let width = frame.size.width
		frame.size.height = CGFloat.max
		let height = self.cell!.cellSizeForBounds(frame).height
		return NSMakeSize(width, height)
	}
	
	public override func textDidChange(notification: NSNotification) {
		super.textDidChange(notification)
		self.invalidateIntrinsicContentSize()
	}
}