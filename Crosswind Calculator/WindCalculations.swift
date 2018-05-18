//
//  WindCalculations.swift
//  Crosswind Calculator
//
//  Created by Corey Davis on 5/17/18.
//  Copyright © 2018 Conxsys LLC. All rights reserved.
//

import Foundation

public typealias ParallelWind = (speed: Double, isTailwind: Bool)

public class WindCalculations {
    public class func crosswind(windSpeed speed: Double, windDirection direction: Double, heading: Double) -> Double {
        let angle = direction - heading
        return speed * sin(angle * (.pi / 180))
    }
    
    public class func parallelWind(windSpeed speed: Double, windDirection direction: Double, heading: Double) -> ParallelWind {
        let angle = direction - heading
        let windSpeed = speed * cos(angle * (.pi / 180))
        let tailwind = windSpeed < 0 ? true : false
        return ParallelWind(speed: windSpeed, isTailwind: tailwind)
    }
}
