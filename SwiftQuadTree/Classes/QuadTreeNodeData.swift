//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

public struct QuadTreeNodeData<T> {
    public let x: Double
    public let y: Double
    public let data: T
    
    public init(x: Double, y: Double, data: T) {
        self.x = x
        self.y = y
        self.data = data
    }
}
