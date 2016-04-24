//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class MyView: UIView {

	lazy var coreView: UIView = {
		let coreView = UIView()
		coreView.backgroundColor = UIColor.lightGrayColor()
		self.addSubview(coreView)
		return coreView
	}()

	private var _margin: CGFloat = 5.0
	

	var margin: CGFloat {
		get { return _margin }
		set { self.setMargin(newValue, animated: false) }
	}

	func setMargin(margin: CGFloat, animated: Bool) {
		let closure: ()->() = {
			self.coreView.frame = CGRectInset(self.bounds, margin, margin)
			self._margin = margin
		}
		if animated {
			UIView.animateWithDuration(0.33) {
				closure()
			}
		}
		else {
			closure()
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.setup()
		self.backgroundColor = UIColor.grayColor()
		self.coreView.frame = CGRectInset(self.bounds, _margin, _margin)
	}

	lazy private var setup: ()->() = {
		let selector = #selector(MyView.tapAction(_:))
		let gesture = UITapGestureRecognizer(target: self, action: selector)
		self.addGestureRecognizer(gesture)
		return {}
	}()

	func tapAction(sender: UITapGestureRecognizer) {
		let value = CGFloat(arc4random_uniform(50))
		self.setMargin(value, animated: true)
	}

}

let myView = MyView(frame: CGRectMake(0, 0, 200, 200))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = myView
myView.setMargin(90.0, animated: true)


