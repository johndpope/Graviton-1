//
//  swift
//  Graviton
//
//  Created by Ben Lu on 9/15/16.
//  Copyright © 2016 Ben Lu. All rights reserved.
//

import SceneKit

// wrap angle from 0 to 2π
func wrapAngle(_ angle: Float) -> Float {
    let twoPi = Float(M_PI * 2)
    var wrapped = fmod(angle, twoPi)
    if wrapped < 0.0 {
        wrapped += twoPi
    }
    return wrapped
}

func calculateMeanAnomaly(fromTime time: Float, gravParam: Float, semimajorAxis: Float) -> Float {
    return wrapAngle(time * sqrt(gravParam / pow(semimajorAxis, 3)))
}

func calculateEccentricAnomaly(eccentricity ec: Float, meanAnomaly m: Float, decimalPoints dp: Int = 7) -> Float {
    let pi: Float = Float(M_PI)
    let maxIter = 30
    var i = 0
    let delta: Float = pow(10, -Float(dp))
    var e: Float
    var f: Float
    
    if ec < 0.8 {
        e = m
    } else {
        e = pi
    }
    
    f = e - ec * sin(m) - m
    
    while (abs(f) > delta) && (i < maxIter) {
        e = e - f / (1.0 - ec * cos(e))
        f = e - ec * sin(e) - m
        i = i + 1
    }
    
    return e
}

func calculateTrueAnomaly(eccentricity: Float, eccentricAnomaly: Float) -> Float {
    return 2 * atan2f(sqrt(1 + eccentricity) * sin(eccentricAnomaly) / 2, sqrt(1 - eccentricity) * cos(eccentricAnomaly) / 2)
}
