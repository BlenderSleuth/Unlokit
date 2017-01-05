//
//  Utils.swift
//  Unlokit
//
//  Created by Ben Sutherland on 30/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit

let π = CGFloat(M_PI)

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * (π / 180)
    }
    func radiansToDegrees() -> CGFloat {
        return (self / π) * 180
    }
}

func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x - right, y: left.y - right)
}

func -(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

func -(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width - right, height: left.height - right)
}

func +(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width + right, height: left.height + right)
}

prefix func -(right: CGPoint) -> CGPoint {
    return CGPoint(x: -right.x, y: -right.y)
}

extension CGPoint {
    func toVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
}

extension CGVector {
    init(_ point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
}

private let version = UIDevice.current.systemVersion
let ios9 = version == "9.3.3" ? true : false
