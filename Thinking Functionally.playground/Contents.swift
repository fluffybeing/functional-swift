//: Playground - noun: a place where people can play

import UIKit


// 1. Functions in Swift are first class variables

// Check point in a range
typealias Position = CGPoint
typealias Distance = CGFloat

func inRange1(target: Position, range: Distance) -> Bool {
    let targetDistance = sqrt(target.x * target.x + target.y * target.y)
    let isInRange = targetDistance <= range
    
    return isInRange
}


// We are not always located at origin
func inRange2(target: Position, ownPosition: Position, range: Distance) -> Bool {
    let dx = ownPosition.x - target.x
    let dy = ownPosition.y - target.y
    
    let targetDistance = sqrt(dx * dx + dy * dy)
    
    return targetDistance <= range
}

// Avoid close ships
let minimumDistance: Distance = 2.0

func inRange3(target: Position, ownPosition: Position, range: Distance) -> Bool {
    let dx = ownPosition.x - target.x
    let dy = ownPosition.y - target.y
    
    let targetDistance = sqrt(dx * dx + dy * dy)
    
    return targetDistance <= range && targetDistance > minimumDistance
}

// Add friendly zone
func inRange4(target: Position, ownPosition: Position, friendly: Position, range: Distance) -> Bool {
    let dx = ownPosition.x - target.x
    let dy = ownPosition.y - target.y
    let targetDistance = sqrt(dx * dx + dy * dy)
    
    let friendlyDx = friendly.x - target.x
    let friendlyDy = friendly.y - target.y
    let friendlyDistance = sqrt(friendlyDx * friendlyDx +
                                friendlyDy * friendlyDy)
    return targetDistance <= range
            && targetDistance > minimumDistance
            && (friendlyDistance > minimumDistance)
}


// Refactor

typealias Region = (Position) -> (Bool)

func circle(radius: Distance) -> Region {
    return { point in
        sqrt(point.x * point.x + point.y * point.y) <= radius
    }
}


func shift(offset: Position, region: @escaping Region) -> Region {
    return { point in
        let shiftedPoint = Position(x: point.x - offset.x,
                                    y: point.x - offset.y)
        
        return region(shiftedPoint)
        
    }
}

func invert(region: @escaping Region) -> Region {
    return { point in !region(point) }
}

func intersection(region1: @escaping Region, region2: @escaping Region) -> Region {
    return {point in region1(point) && region2(point)}
}

func union(region1: @escaping Region, region2: @escaping Region) -> Region {
    return {point in region1(point) || region2(point)}
}

func difference(region: @escaping Region, minusRegion: @escaping Region) -> Region {
    return intersection(region1: region, region2: invert(region: minusRegion))
}


// Now make the inRange

func inRange(ownPosition: Position, target: Position, friendly: Position, range: Distance) -> Bool {
    let rangeRegion = difference(region: circle(radius: range), minusRegion: circle(radius: minimumDistance))
    
    let targetRegion = shift(offset: ownPosition, region: rangeRegion)
    let friendlyRegion = shift(offset: friendly, region: circle(radius: minimumDistance))
    let resultRegion = difference(region: targetRegion, minusRegion: friendlyRegion)
    
    return resultRegion(target)
}