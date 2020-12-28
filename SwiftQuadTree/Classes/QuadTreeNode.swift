//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public class QuadTreeNode<T> {
    private var northWest: QuadTreeNode?
    private var northEast: QuadTreeNode?
    private var southWest: QuadTreeNode?
    private var southEast: QuadTreeNode?
    private var boundingBox: BoundingBox
    private var bucketCapacity: Int
    private var points: [QuadTreeNodeData<T>] = []

    public var isLeaf: Bool {
        northWest == nil
    }
    
    public init(boundary: BoundingBox, capacity: Int, nodes: [QuadTreeNodeData<T>] = []) {
        self.boundingBox = boundary
        self.bucketCapacity = capacity
        
        for node in nodes {
            insert(node: node)
        }
    }
    
    public func subdivide() {
        let xMid = (boundingBox.xf + boundingBox.x0) / 2.0
        let yMid = (boundingBox.yf + boundingBox.y0) / 2.0
        
        let northWestBox = BoundingBox(x: boundingBox.x0, y: boundingBox.y0, xf: xMid, yf: yMid)
        northWest = QuadTreeNode(boundary: northWestBox, capacity: bucketCapacity)
        
        let northEastBox = BoundingBox(x: xMid, y: boundingBox.y0, xf: boundingBox.xf, yf: yMid)
        northEast = QuadTreeNode(boundary: northEastBox, capacity: bucketCapacity)
        
        let southWestBox = BoundingBox(x: boundingBox.x0, y: yMid, xf: xMid, yf: boundingBox.yf)
        southWest = QuadTreeNode(boundary: southWestBox, capacity: bucketCapacity)
        
        let southEastBox = BoundingBox(x: xMid, y: yMid, xf: boundingBox.xf, yf: boundingBox.yf)
        southEast = QuadTreeNode(boundary: southEastBox, capacity: bucketCapacity)
    }

    // Insert a point into the QuadTree
    @discardableResult
    public func insert(node: QuadTreeNodeData<T>) -> Bool {
        // Ignore objects that do not belong in this quad tree
        guard boundingBox.containsData(data: node) else {
            return false // object cannot be added
        }
        
        // If there is space in this quad tree and if doesn't have subdivisions, add the object here
        guard bucketCapacity < points.count  else {
            points.append(node)
            return true
        }
        
        // Otherwise, subdivide and then add the point to whichever node will accept it
        if isLeaf {
            subdivide()
        }
        
        // We have to add the points/data contained into this quad array to the new quads if we only want
        // the last node to hold the data
        if northWest!.insert(node: node) { return true }
        if northEast!.insert(node: node) { return true }
        if southWest!.insert(node: node) { return true }
        if southEast!.insert(node: node) { return true }

        // Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
        return false
    }

    // Find all points that appear within a range
    public func queryRange(range: BoundingBox) -> [QuadTreeNodeData<T>] {
        // Prepare an array of results
        var pointsInRange: [QuadTreeNodeData<T>] = []
        // Automatically abort if the range does not intersect this quad
        guard boundingBox.intersectWith(other: range) else {
            return [] // empty list
        }

        // Check objects at this quad level
        pointsInRange += points.filter { range.containsData(data: $0) }

        // Terminate here, if there are no children
        guard !isLeaf else {
            return pointsInRange
        }
        
        // Otherwise, add the points from the children
        pointsInRange += northWest!.queryRange(range: range)
        pointsInRange += northEast!.queryRange(range: range)
        pointsInRange += southWest!.queryRange(range: range)
        pointsInRange += southEast!.queryRange(range: range)
        return pointsInRange
    }
}
