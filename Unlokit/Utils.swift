//
//  Utils.swift
//  Unlokit
//
//  Created by Ben Sutherland on 30/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

//File to contain all the help methods that I need for my projects
//Sort of like a dump file when I need something global

import SpriteKit

//********* Degree Functions ***************************
let π = CGFloat(M_PI)

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

import UIKit

extension UIImage {
	public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
		let degreesToRadians: (CGFloat) -> CGFloat = {
			return $0 / 180.0 * CGFloat(M_PI)
		}
		
		// calculate the size of the rotated view's containing box for our drawing space
		let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
		let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
		rotatedViewBox.transform = t
		let rotatedSize = rotatedViewBox.frame.size
		
		// Create the bitmap context
		UIGraphicsBeginImageContext(rotatedSize)
		let bitmap = UIGraphicsGetCurrentContext()!
		
		// Move the origin to the middle of the image so we will rotate and scale around the center.
		bitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
		
		//   // Rotate the image context
		bitmap.rotate(by: degreesToRadians(degrees));
		
		// Now, draw the rotated/scaled image into the context
		var yFlip: CGFloat
		
		if(flip){
			yFlip = CGFloat(-1.0)
		} else {
			yFlip = CGFloat(1.0)
		}
		
		bitmap.scaleBy(x: yFlip, y: -1.0)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return newImage
	}
}

extension CGRect {
	mutating func rotate(by angle: CGFloat) {
	}
}

//********* Other Global stuff ***************************
private let version = UIDevice.current.systemVersion
let ios9 = version[version.startIndex] == "9" ? true : false
let iPhone = UIDevice.current.model == "iPhone"

//********* SKNode extension *****************************
extension SKNode
{
	/** 
	Adds an action to the list of actions executed by the node.
	- parameters:
		- action : The action to perform.
		- withKey: A unique key used to identify the action.
		- block : A completion block called when the action completes.
	*/
	func run(_ action: SKAction, withKey: String, completion block:@escaping ((Void) -> Void)) {
			let completionAction = SKAction.run(block)
			let compositeAction = SKAction.sequence([action, completionAction])
			run(compositeAction, withKey: withKey)
	}
	
	func actionForKeyIsRunning(key: String) -> Bool {
		return self.action(forKey: key) != nil ? true : false
	}
}










