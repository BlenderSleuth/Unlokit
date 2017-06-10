//
//  Utils.swift
//  Unlokit
//
//  Created by Ben Sutherland on 30/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

// File to contain all the help methods that I need for my projects
// Sort of like a dump file when I need something with a public scope

import SpriteKit

//********* Degree Functions ***************************
let π = CGFloat.pi

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * (π / 180)
    }
    func radiansToDegrees() -> CGFloat {
        return (self / π) * 180
    }
}

extension Float {
    func degreesToRadians() -> Float {
        return self * (Float(π) / 180)
    }
    func radiansToDegrees() -> Float {
        return (self / Float(π)) * 180
    }
}

//********* CGPoint Functions ***************************
func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}
func -= (left: inout CGPoint, right: CGPoint) {
	left.x -= right.x
	left.y -= right.y
}
func *= (left: inout CGPoint, right: CGPoint) {
	left.x *= right.x
	left.y *= right.y
}
func /= (left: inout CGPoint, right: CGPoint) {
	left.x /= right.x
	left.y /= right.y
}

func + (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x + right, y: left.y + right)
}
func - (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x - right, y: left.y - right)
}
func * (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x * right, y: left.y * right)
}
func / (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x / right, y: left.y / right)
}

func += (left: inout CGPoint, right: CGFloat) {
	left.x += right
	left.y += right
}
func -= (left: inout CGPoint, right: CGFloat) {
	left.x -= right
	left.y -= right
}
func *= (left: inout CGPoint, right: CGFloat) {
	left.x *= right
	left.y *= right
}
func /= (left: inout CGPoint, right: CGFloat) {
	left.x /= right
	left.y /= right
}

prefix func -(right: CGPoint) -> CGPoint {
	return CGPoint(x: -right.x, y: -right.y)
}

func distance(between point1: CGPoint, and point2: CGPoint) -> CGFloat {
	let d1 = (point1.x - point2.x)
	let d2 = (point1.y - point2.y)
	return CGFloat(sqrt(d1 * d1 + d2 * d2))
}

//********* CGVector Functions ***************************
func + (left: CGVector, right: CGVector) -> CGVector {
	return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}
func - (left: CGVector, right: CGVector) -> CGVector {
	return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}
func * (left: CGVector, right: CGVector) -> CGVector {
	return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}
func / (left: CGVector, right: CGVector) -> CGVector {
	return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

func += (left: inout CGVector, right: CGVector) {
	left.dx += right.dx
	left.dy += right.dy
}
func -= (left: inout CGVector, right: CGVector) {
	left.dx -= right.dx
	left.dy -= right.dy
}
func *= (left: inout CGVector, right: CGVector) {
	left.dx *= right.dx
	left.dy *= right.dy
}
func /= (left: inout CGVector, right: CGVector) {
	left.dx /= right.dx
	left.dy /= right.dy
}

func + (left: CGVector, right: CGFloat) -> CGVector {
	return CGVector(dx: left.dx + right, dy: left.dy + right)
}
func - (left: CGVector, right: CGFloat) -> CGVector {
	return CGVector(dx: left.dx - right, dy: left.dy - right)
}
func * (left: CGVector, right: CGFloat) -> CGVector {
	return CGVector(dx: left.dx * right, dy: left.dy * right)
}
func / (left: CGVector, right: CGFloat) -> CGVector {
	return CGVector(dx: left.dx / right, dy: left.dy / right)
}

func += (left: inout CGVector, right: CGFloat) {
	left.dx += right
	left.dy += right
}
func -= (left: inout CGVector, right: CGFloat) {
	left.dx -= right
	left.dy -= right
}
func *= (left: inout CGVector, right: CGFloat) {
	left.dx *= right
	left.dy *= right
}
func /= (left: inout CGVector, right: CGFloat) {
	left.dx /= right
	left.dy /= right
}

//Convert CGPoint to CGVector with type casting syntax
extension CGVector {
	init(_ point: CGPoint) {
		self.init(dx: point.x, dy: point.y)
	}
}

//********* CGSize Functions ***************************
func + (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width + right.width, height: left.height + right.height)
}
func - (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width - right.width, height: left.height - right.height)
}
func * (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width * right.width, height: left.height * right.height)
}
func / (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width / right.width, height: left.height / right.height)
}

func += (left: inout CGSize, right: CGSize) {
	left.width += right.width
	left.height += right.height
}
func -= (left: inout CGSize, right: CGSize) {
	left.width -= right.width
	left.height -= right.height
}
func *= (left: inout CGSize, right: CGSize) {
	left.width *= right.width
	left.height *= right.height
}
func /= (left: inout CGSize, right: CGSize) {
	left.width /= right.width
	left.height /= right.height
}

func + (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width + right, height: left.height + right)
}
func - (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width - right, height: left.height - right)
}
func * (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width * right, height: left.height * right)
}
func / (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width / right, height: left.height / right)
}

func += (left: inout CGSize, right: CGFloat) {
	left.width += right
	left.height += right
}
func -= (left: inout CGSize, right: CGFloat) {
	left.width -= right
	left.height -= right
}
func *= (left: inout CGSize, right: CGFloat) {
	left.width *= right
	left.height *= right
}
func /= (left: inout CGSize, right: CGFloat) {
	left.width /= right
	left.height /= right
}

prefix func -(right: CGSize) -> CGSize {
	return CGSize(width: -right.width, height: -right.height)
}

//********* CGRect Functions ***************************
func + (left: CGRect, right: CGFloat) -> CGRect {
	let origin = CGPoint(x: left.origin.x - right / 2, y: left.origin.y - right / 2)
	let size = left.size + right
	return CGRect(origin: origin, size: size)
}
func - (left: CGRect, right: CGFloat) -> CGRect {
	let origin = CGPoint(x: left.origin.x + right / 2, y: left.origin.y + right / 2)
	let size = left.size - right
	return CGRect(origin: origin, size: size)
}
func * (left: CGRect, right: CGFloat) -> CGRect {
	let size = left.size * right
	let origin = CGPoint(x: left.origin.x - size.width/2, y: left.origin.y - size.height/2)

	return CGRect(origin: origin, size: size)
}
func / (left: CGRect, right: CGFloat) -> CGRect {
	let size = left.size / right
	let origin = CGPoint(x: left.origin.x + size.width/2, y: left.origin.y + size.height/2)

	return CGRect(origin: origin, size: size)
}

func += (left: inout CGRect, right: CGFloat) {
	left.origin = CGPoint(x: left.origin.x - right / 2, y: left.origin.y - right / 2)
	left.size += right
}
func -= (left: inout CGRect, right: CGFloat) {
	left.origin = CGPoint(x: left.origin.x + right / 2, y: left.origin.y + right / 2)
	left.size -= right
}
func *= (left: inout CGRect, right: CGFloat) {
	left.size *= right
	left.origin = CGPoint(x: left.origin.x - left.size.width/2, y: left.origin.y - left.size.height/2)
}
func /= (left: inout CGRect, right: CGFloat) {
	left.size /= right
	left.origin = CGPoint(x: left.origin.x + left.size.width/2, y: left.origin.y + left.size.height/2)
}

prefix func -(right: CGRect) -> CGRect {
	return CGRect(origin: -right.origin, size: -right.size)
}

//********* CGAffine Function ****************************
func += (left: inout CGAffineTransform, right: CGAffineTransform) {
	left = left.concatenating(right)
}

//********* Other Public stuff ***************************
let appID = 1207632456
private let version = UIDevice.current.systemVersion
let ios9 = version[version.startIndex] == "9"
let iPhone = UIDevice.current.model == "iPhone"

// To check for the pesky 3:2 aspect ratio
private func checkForiPhone4s() -> Bool {
	// I don't actually know what this does, but it works
	var systemInfo = utsname()
	uname(&systemInfo)
	let modelCode = withUnsafePointer(to: &systemInfo.machine) {
		$0.withMemoryRebound(to: CChar.self, capacity: 1) {
			ptr in String.init(validatingUTF8: ptr)
		}
	}
	
	// Check for iphone 4s
	return modelCode == "iPhone4,1"
}
let iPhone4s = checkForiPhone4s()

let neuropolFont = "NeuropolXRg-Regular"

//********* SKNode extension *****************************
extension SKNode {
	/** 
	Adds an action to the list of actions executed by the node.
	- parameters:
		- action : The action to perform.
		- withKey : A unique key used to identify the action.
		- block : A completion block called when the action completes.
	*/
	func run(_ action: SKAction, withKey: String, completion block: @escaping ((Void) -> Void)) {
			let completionAction = SKAction.run(block)
			let compositeAction = SKAction.sequence([action, completionAction])
			run(compositeAction, withKey: withKey)
	}
	
	func actionForKeyIsRunning(key: String) -> Bool {
		return self.action(forKey: key) != nil
	}
}

//********* String extension *****************************
extension String {
	func numbers() -> Int? {
		let numberStringArray = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
		
		return Int(numberStringArray.joined())
	}
}

//********* Array extension *****************************
extension Array {
	mutating func moveNext() {
		let first = self[0]
		self.remove(at: 0)
		self.append(first)
	}
}

// **** Weak wrapper to create a list of weak objects ****
struct Weak<T> where T: AnyObject {
	weak var _value : T?
	
	init (value: T) {
		_value = value
	}
	
	func get() -> T? {
		return _value
	}
}

//********* Plist Loading *****************************
func getDefaultLevelsFromPlist(stage stageNumber: Int) -> [Level]{
	// Get plist
	let plist = Bundle.main.path(forResource: "LevelData", ofType: "plist")!
	let stageDict = NSDictionary(contentsOfFile: plist) as! [String: [String: Any]]
	let levelDict = stageDict["Stage\(stageNumber)"]!
	
	var levelArray = [Level]()
	
	// Iterate through levels in plist
	for (levelNumberStr, _) in levelDict {
		if let levelNumber = levelNumberStr.numbers() {
			
			// Mark first level as available
			let available: Bool
			if stageNumber == 1 && levelNumber == 1 {
				available = true
			} else {
				available = false
			}
			
			let level = Level(number: levelNumber, stageNumber: stageNumber, available: available)
			levelArray.append(level)
		}
	}
	// Sort array to be in the correct order
	levelArray.sort {
		$0.number < $1.number
	}
	
	return levelArray
}

//********* SpriteKit functions *****************************
func rotationRelativeToSceneFor(node: SKNode) -> CGFloat {
	var nodeRotation = CGFloat(0)
	var tempNode: SKNode? = node

	// Loop through parents until scene or nil
	while !(tempNode is SKScene) && (tempNode != nil){
		nodeRotation += tempNode!.zRotation
		tempNode = tempNode!.parent
	}

	return nodeRotation
}
func delay(_ delay: Double, block: @escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
}

//********* User Defaults functions ************************
enum CheckKey: String {
	case isFirstAppLaunch = "hasAppAlreadyLaunchedOnce"
	case isFirstGameLaunch = "hasGameAlreadyLaunchedOnce"
}

private func checkValueFor(key: CheckKey, reset: Bool = false) -> Bool {
	let defaults = UserDefaults.standard
	let key = key.rawValue
	
	if defaults.bool(forKey: key) {
		return false
	} else {
		if reset {
			defaults.set(true, forKey: key)
		}
		return true
	}
}
func setValueFor(key: CheckKey) {
	let defaults = UserDefaults.standard
	let key = key.rawValue
	
	defaults.set(true, forKey: key)
}

// Run once when initialised
public let isFirstAppLaunch = checkValueFor(key: .isFirstAppLaunch, reset: true)
public let isFirstGameLaunch = checkValueFor(key: .isFirstGameLaunch)

//********* Texture functions for tutorial ************************
func invertTexture(_ texture: SKTexture) -> SKTexture? {
    let width = Int(texture.size().width)
    let height = Int(texture.size().height)
    let cgImage = texture.cgImage()
    if let cfData = cgImage.dataProvider,
        let mutableData = CFDataCreateMutableCopy(nil, 0, cfData.data),
        let mutablePtr = CFDataGetMutableBytePtr(mutableData) {
        
        for x in 0..<width {
            for y in 0..<height {
                let pixelAddress = x * 4 + y * width * 4
                
                // Check alpha bit
                let alphaAddress = pixelAddress + 3
                
                let currentColour = mutablePtr.advanced(by: alphaAddress).pointee
                
                // Invert alpha
                mutablePtr.advanced(by: alphaAddress).pointee = 255 - currentColour
            }
        }
        
        return SKTexture(data: mutableData as Data, size: texture.size())
    }
    return nil
}

func generateTextureWithHole(size: CGSize,
                             radius: CGFloat,
                             position: CGPoint,
                             backgroundColour: UIColor = .black) -> SKTexture {
    
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()!
    
    let circleRect = CGRect(x: position.x - radius,
                            y: position.y - radius,
                            width: radius * 2,
                            height: radius * 2)
    
    // Background Colour
    backgroundColour.withAlphaComponent(0.1).setFill()
    context.fill(CGRect(origin: CGPoint.zero, size: size))
    
    // Ellipse
    UIColor.black.setFill()
    context.fillEllipse(in: circleRect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let texture = SKTexture(image: image)
    
    //let filter = CIFilter(name: "CIGaussianBlue", withInputParameters: ["inputImage":texture.cgImage()])!
    //let blurTexture = texture.applying(filter)
    
    let invertedTexture = invertTexture(texture)!
    
    return invertedTexture
}

