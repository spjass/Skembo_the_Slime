//
//  CollisionHelper.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 28.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

let SLIME_CATEGORY : UInt32 = 1 << 0
let EDGE_CATEGORY : UInt32 = 1 << 1
let GROUND_CATEGORY : UInt32 = 1 << 2
let WALL_CATEGORY : UInt32 = 1 << 3
let GOAL_CATEGORY : UInt32 = 1 << 4
