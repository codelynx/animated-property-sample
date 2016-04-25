#Animatable Properties Implementation Sample

iOS provides some animatable properties for some components.  A single property may have multiple methods one with animated, and the other is implecity not animated.


```.swift
func setNavigationBarHidden(_ hidden: Bool, animated animated: Bool)
var navigationBarHidden: Bool
```

```.swift
func setToolbarItems(_ toolbarItems: [UIBarButtonItem]?, animated animated: Bool)
var toolbarItems: [UIBarButtonItem]?
```

You may want to implement similar animatable properties for your own UIView subclass.  This sample code demonstrates how to design and implement your own animatable properties.  In this example, `MyView` provides animatable property `margin`, and `margin` 


<img width="470" alt="Screen Shot" src="https://qiita-image-store.s3.amazonaws.com/0/65634/513025eb-c672-f438-f252-d249ca092098.png">

This sample code demonstrate, how to implement your own animatable properties, one with animable option, and the other without animatable option.  The property and method may be look like as follows.

```.swift
	var margin: CGFloat
	func set(margin margin: CGFloat, animated: Bool)
```

When you like `margin` to be animatable, you may want to `margin` to be computed property rather than strored property.  Then you will need actual stored property, note it is a private property.

```.swift
class MyView: UIView {

	lazy var coreView: UIView = {
		let coreView = UIView()
		coreView.backgroundColor = UIColor.lightGrayColor()
		self.addSubview(coreView)
		return coreView
	}()

	private var _margin: CGFloat = 5.0 // <--actual property

	var margin: CGFloat { // <-- computed properties
		get { return _margin }
		set { self.set(margin: newValue, animated: false) }
	}

	func set(margin margin: CGFloat, animated: Bool) {
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
```

You may try Playground.  When you tap on `MyView`, then random generated number will be for `marge` property with animation.


```.swift
let myView = MyView(frame: CGRectMake(0, 0, 200, 200))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = myView
myView.setMargin(90.0, animated: true)
```

When you tap on `MyView`, then margin will be set randomly with animation.

