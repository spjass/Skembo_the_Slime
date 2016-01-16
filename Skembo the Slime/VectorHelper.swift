//
//  VectorHelper.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 30.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

func rwAdd(a:CGPoint, b:CGPoint ) -> CGPoint  {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

func rwSub(a:CGPoint, b:CGPoint ) -> CGPoint  {
    return CGPointMake(a.x - b.x, a.y - b.y);
}


func rwMult(a:CGPoint, b:CGFloat ) -> CGPoint  {
    return CGPointMake(a.x * b, a.y * b);
}

func rwLength(a:CGPoint) -> CGFloat  {
    return sqrt(a.x * a.x + a.y * a.y);
}

func rwNormalize(a:CGPoint) -> CGPoint  {
    var length:CGFloat = rwLength(a)
    return CGPointMake(a.x / length, a.y / length);
}
