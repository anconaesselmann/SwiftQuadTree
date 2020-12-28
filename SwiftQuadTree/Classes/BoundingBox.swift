//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct BoundingBox {
    public let x0: Double
    public let y0: Double
    public let xf: Double
    public let yf: Double

    public let height: Double
    public let width: Double
    public let centerX: Double
    public let centerY: Double

    public init(x: Double, y: Double, width: Double, height: Double) {
        x0 = x
        y0 = y
        xf = x + width
        yf = y + height
        self.width = width
        self.height = height
        centerX = x0 + (width / 2.0)
        centerY = y0 + (height / 2.0)
    }
    
    public init(x: Double, y: Double, xf: Double, yf: Double) {
        x0 = x
        y0 = y
        self.xf = xf
        self.yf = yf
        height = abs(yf - y0)
        width = abs(xf - x0)
        centerX = x0 + (width / 2)
        centerY = y0 + (height / 2)
    }
    
    public func containsData<T>(data: QuadTreeNodeData<T>) -> Bool {
        let containsX = x0 <= data.x && data.x <= xf
        let containsY = y0 <= data.y && data.y <= yf
        return containsX && containsY
    }
    
    public func intersectWith(other: BoundingBox) -> Bool {
        let intersectsX = abs(centerX - other.centerX) * 2 < (width + other.width)
        let intersectsY = abs(centerY - other.centerY) * 2 < (height + other.height)
        return intersectsX && intersectsY
    }
}
